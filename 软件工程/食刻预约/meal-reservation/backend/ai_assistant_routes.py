"""Simple AI assistant API with a lightweight operations knowledge base.

This endpoint does not call external LLMs. It uses a curated Q&A set with
basic similarity scoring so front-end can prototype the floating assistant.
"""
import os
import requests
from difflib import SequenceMatcher
from typing import Dict, List, Tuple

from flask import Blueprint, jsonify, request, g

from auxiliary_function import optional_token_required
from Models import db, User, Restaurant, Dish, Order, Review, MerchantApplication

# Blueprint
ai_assistant_bp = Blueprint('ai_assistant', __name__, url_prefix='/api/ai')


# Minimal operations knowledge base. Keep answers actionable and concise.
KNOWLEDGE_BASE: List[Dict] = [
    {
        "title": "账号登录与注册",
        "questions": [
            "怎么登录系统",
            "如何注册账号",
            "登录失败怎么办",
        ],
        "answer": (
            "在登录页输入手机号/用户名+密码即可登录；首次使用点击注册，按提示填写必填信息并验证手机。"
            "若忘记密码可使用找回密码流程，通过短信验证码重置。"
        ),
        "keywords": ["登录", "注册", "找回密码", "验证码"],
    },
    {
        "title": "商家入驻",
        "questions": [
            "怎么提交商家申请",
            "商户入驻需要什么材料",
            "商家审核多久",
        ],
        "answer": (
            "在商家中心提交入驻申请，需提供营业执照、法人身份证、门店基本信息和联系方式；"
            "提交后可在“申请记录”查看状态，审核通过后即可创建菜单和管理订单。"
        ),
        "keywords": ["商家", "入驻", "申请", "审核", "营业执照"],
    },
    {
        "title": "菜单与上架",
        "questions": [
            "如何上架菜品",
            "菜品图片上传路径",
            "库存管理",
        ],
        "answer": (
            "进入商家后台-菜单管理，点击新增菜品，填写名称、价格、分类、库存并上传图片；"
            "支持随时下架或调整库存，库存为0时前台会显示售罄。"
        ),
        "keywords": ["菜品", "上架", "菜单", "库存", "图片上传"],
    },
    {
        "title": "订单与桌台",
        "questions": [
            "如何查看新订单",
            "桌位管理怎么用",
            "排队叫号在哪",
        ],
        "answer": (
            "在商家后台-订单队列查看实时订单，支持接单/拒单与状态更新；"
            "桌台管理可新增、编辑、禁用桌位并设置二维码；"
            "排队叫号在订单队列内，可按就餐桌台或取餐号通知用户。"
        ),
        "keywords": ["订单", "桌台", "排队", "叫号", "队列"],
    },
    {
        "title": "通知与短信",
        "questions": [
            "短信验证码不收到",
            "推送通知怎么配置",
            "上新通知",
        ],
        "answer": (
            "验证码发送失败通常是请求过于频繁或号码格式错误，稍后重试；"
            "商家可在通知设置里开启上新/优惠券推送，用户侧需要允许消息权限；"
            "如持续异常请联系管理员检查短信服务和网关配额。"
        ),
        "keywords": ["短信", "验证码", "推送", "通知", "上新"],
    },
    {
        "title": "评价与申诉",
        "questions": [
            "差评怎么处理",
            "评价被屏蔽",
            "如何发起申诉",
        ],
        "answer": (
            "在评价管理中回复或标记异常评价，必要时提交申诉并附证据；"
            "申诉提交后可在申诉列表查看处理进度，平台会在审核后给出结果。"
        ),
        "keywords": ["评价", "申诉", "差评", "回复"],
    },
    {
        "title": "个人信息与安全",
        "questions": [
            "怎么修改头像",
            "如何修改密码",
            "更换手机号",
        ],
        "answer": (
            "在“个人中心-编辑资料”中可以上传新头像、修改昵称；"
            "修改密码或更换手机号需要进行短信验证，以确保账号安全。"
        ),
        "keywords": ["头像", "密码", "手机号", "个人中心", "资料"],
    },
    {
        "title": "优惠券与支付",
        "questions": [
            "怎么使用优惠券",
            "支付方式有哪些",
            "退款怎么操作",
        ],
        "answer": (
            "下单结算时，系统会自动列出可用优惠券，选择即可抵扣；"
            "支持微信、支付宝等主流支付方式；如需退款，请在订单详情页申请，商家审核通过后原路退回。"
        ),
        "keywords": ["优惠券", "支付", "退款", "结算", "抵扣"],
    },
    {
        "title": "搜索与收藏",
        "questions": [
            "怎么搜索菜品",
            "如何收藏店铺",
            "找不到想吃的菜",
        ],
        "answer": (
            "首页顶部搜索栏支持按菜名、商家名搜索；"
            "进入商家主页点击右上角“心形”图标即可收藏，方便下次快速找到。"
        ),
        "keywords": ["搜索", "收藏", "查找", "店铺"],
    },
]


def call_modelscope_llm(question: str) -> Tuple[str, str]:
    """Call ModelScope (DashScope) API for fallback answer. Returns (answer, error_msg)."""
    # ============================================================
    # TODO: 请在此处直接粘贴您的 DashScope API Key
    # 例如: api_key = "sk-1234567890abcdef1234567890abcdef"
    # ============================================================
    api_key = os.getenv("MODELSCOPE_API_KEY", "")

    # 如果上面没有修改，尝试从环境变量获取
    if "YOUR_REAL_API_KEY_HERE" in api_key:
        api_key = os.getenv("DASHSCOPE_API_KEY", "")
    
    # 简单的检查，防止使用默认占位符调用
    if not api_key or "YOUR_REAL_API_KEY_HERE" in api_key or "YOUR_DASHSCOPE_API_KEY" in api_key:
        return None, "API Key not configured"

    # 使用 OpenAI 兼容接口 (ModelScope API-Inference)
    # 文档: https://modelscope.cn/docs/api_inference
    url = "https://api-inference.modelscope.cn/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    # 使用 Qwen/Qwen2.5-Coder-32B-Instruct 模型 (ModelScope Model-Id)
    payload = {
        "model": "Qwen/Qwen2.5-Coder-32B-Instruct",
        "messages": [
            {
                "role": "system",
                "content": "你是一个啊对的对的队负责回答食刻预约餐饮系统的小猫娘，请简短且尊敬地回答主人关于系统操作或餐饮管理，点餐的问题。注意加emoji"
            },
            {
                "role": "user",
                "content": question
            }
        ],
        "stream": False
    }

    try:
        response = requests.post(url, json=payload, headers=headers, timeout=10)
        if response.status_code == 200:
            data = response.json()
            if 'choices' in data and len(data['choices']) > 0:
                return data['choices'][0]['message']['content'], None
        
        error_msg = f"API Error {response.status_code}: {response.text}"
        print(f"ModelScope API Error: {error_msg}")
        return None, error_msg
    except Exception as e:
        print(f"Call LLM failed: {e}")
        return None, str(e)


def _score_question(user_question: str, entry: Dict) -> Tuple[float, str]:
    """Return similarity score and the matched question text."""
    best_question = ""
    best_score = 0.0
    for q in entry.get("questions", []):
        score = SequenceMatcher(None, user_question, q).ratio()
        if score > best_score:
            best_score = score
            best_question = q
    # Keyword boost
    keyword_hits = sum(1 for kw in entry.get("keywords", []) if kw in user_question)
    best_score += 0.08 * keyword_hits
    return best_score, best_question


def _find_best_answer(user_question: str) -> Dict:
    """Find the best matching knowledge entry. Returns dict with score and content."""
    best_entry = None
    best_score = 0.0
    best_question = ""
    for entry in KNOWLEDGE_BASE:
        score, matched_q = _score_question(user_question, entry)
        if score > best_score:
            best_score = score
            best_entry = entry
            best_question = matched_q
    return {
        "score": round(best_score, 3),
        "matched_question": best_question,
        "answer": best_entry.get("answer") if best_entry else None,
        "title": best_entry.get("title") if best_entry else None,
    }


def query_database(question: str, user_id: int = None) -> Tuple[str, bool]:
    """
    根据用户问题查询数据库，返回 (答案, 是否为数据库查询)
    """
    question_lower = question.lower()
    
    try:
        # ==================== 欢迎/帮助信息 ====================
        if any(kw in question_lower for kw in ['你好', '在吗', '你是谁', '帮助', '能做什么', '怎么用', '功能', 'help', '你会什么']):
            answer = """喵~ 主人好呀！我是食刻预约系统的AI小助手 🐱✨

我可以帮您做这些事情：

📋 **订单管理**
• 查看我的订单："我的订单"
• 订单状态查询："订单状态"

🏪 **店铺信息**
• 查看所有店铺："有哪些店铺"
• 查看店铺菜单："XX餐厅有哪些菜"

🍽️ **菜品推荐**
• 热门推荐："推荐什么好吃的"
• 查看评价："最近的评价"

📊 **系统统计**
• 数据统计："系统数据统计"

💡 **系统帮助**
• 操作指南："怎么登录"、"如何注册"
• 商家入驻："如何入驻商家"

有什么想问的就直接说吧，主人~ 😊"""
            return answer, True
        
        # ==================== 订单查询 ====================
        if any(kw in question_lower for kw in ['订单', '我的订单', '订单状态', '订单记录', '点了什么']):
            if not user_id:
                return "请先登录后查询订单信息哦~", True
            
            orders = Order.query.filter_by(user_id=user_id).order_by(Order.created_at.desc()).limit(5).all()
            if not orders:
                return "您还没有任何订单记录哦~", True
            
            answer = f"主人，您最近有{len(orders)}个订单：\n"
            for idx, order in enumerate(orders, 1):
                restaurant = Restaurant.query.get(order.restaurant_id)
                status_map = {
                    'pending': '待接单', 'confirmed': '已确认', 
                    'preparing': '准备中', 'ready': '已完成',
                    'completed': '已完成', 'cancelled': '已取消'
                }
                status = status_map.get(order.status, order.status)
                r_name = restaurant.name if restaurant else '未知商家'
                answer += f"{idx}. {r_name} - ¥{order.total_price} - {status}\n"
            return answer, True
        
        # ==================== 店铺/商家查询 ====================
        if any(kw in question_lower for kw in ['商家', '餐厅', '店铺', '有哪些店', '哪些餐厅', '店家']):
            restaurants = Restaurant.query.limit(10).all()
            
            if not restaurants:
                return "暂时还没有商家信息哦~", True
            
            answer = f"主人，目前有{len(restaurants)}家店铺：\n"
            for idx, r in enumerate(restaurants, 1):
                addr = r.address or '暂无地址'
                phone = r.phone or ''
                answer += f"{idx}. 【{r.name}】- {addr}\n"
            return answer, True
        
        # ==================== 特定店铺菜品查询 ====================
        if any(kw in question_lower for kw in ['有哪些菜', '有什么菜', '菜单', '菜品有哪些', '都有什么菜', '卖什么']):
            all_restaurants = Restaurant.query.all()
            target_restaurant = None
            for r in all_restaurants:
                if r.name and r.name in question:
                    target_restaurant = r
                    break
            
            if target_restaurant:
                dishes = Dish.query.filter_by(restaurant_id=target_restaurant.id).order_by(Dish.monthly_sales.desc()).all()
                if not dishes:
                    return f"主人，【{target_restaurant.name}】暂时还没有上架菜品哦~", True
                
                answer = f"主人，【{target_restaurant.name}】有{len(dishes)}道菜品：\n"
                for idx, dish in enumerate(dishes, 1):
                    price = f"¥{dish.price}"
                    stock = f" (库存:{dish.stock_quantity})" if dish.stock_quantity is not None else ""
                    sales = f" (月售{dish.monthly_sales})" if dish.monthly_sales and dish.monthly_sales > 0 else ""
                    answer += f"{idx}. {dish.name} - {price}{stock}{sales}\n"
                return answer, True
            else:
                restaurants = Restaurant.query.limit(5).all()
                if restaurants:
                    names = "、".join([r.name for r in restaurants])
                    return f"主人，请告诉我您想查看哪家店铺的菜品哦~ 目前有：{names} 等店铺", True
                return "主人，请告诉我您想查看哪家店铺的菜品哦~", True
        
        # ==================== 热门菜品/推荐查询 ====================
        if any(kw in question_lower for kw in ['热门菜', '推荐菜', '什么好吃', '菜品推荐', '推荐', '好吃的']):
            dishes = Dish.query.order_by(Dish.monthly_sales.desc()).limit(8).all()
            if not dishes:
                return "暂时没有菜品信息哦~", True
            
            answer = "主人，这些菜品超受欢迎呢：\n"
            for idx, dish in enumerate(dishes, 1):
                restaurant = Restaurant.query.get(dish.restaurant_id)
                r_name = restaurant.name if restaurant else '未知商家'
                sales = dish.monthly_sales if dish.monthly_sales else 0
                answer += f"{idx}. 【{dish.name}】- ¥{dish.price} - {r_name} (月售{sales})\n"
            return answer, True
        
        # ==================== 评价查询 ====================
        if any(kw in question_lower for kw in ['评价', '评论', '好评', '差评', '口碑']):
            # 只查询审核通过的评论
            reviews = Review.query.filter_by(review_status='approved').order_by(Review.created_at.desc()).limit(5).all()
            if not reviews:
                return "暂时还没有评价信息哦~", True
            
            answer = "主人，这是最新的一些评价：\n"
            for idx, review in enumerate(reviews, 1):
                restaurant = Restaurant.query.get(review.restaurant_id)
                r_name = restaurant.name if restaurant else '未知商家'
                stars = '⭐' * (review.rating if review.rating else 0)
                content = review.content[:25] + '...' if review.content and len(review.content) > 25 else (review.content or '无内容')
                answer += f"{idx}. 【{r_name}】{stars} - {content}\n"
            return answer, True
        
        # ==================== 统计信息查询 ====================
        if any(kw in question_lower for kw in ['多少家店', '统计', '数据', '总共', '一共']):
            restaurant_count = Restaurant.query.count()
            dish_count = Dish.query.count()
            order_count = Order.query.count()
            review_count = Review.query.count()
            user_count = User.query.count()
            
            answer = f"主人，这是系统的统计数据：\n"
            answer += f"🏪 商家总数：{restaurant_count} 家\n"
            answer += f"🍽️ 菜品总数：{dish_count} 道\n"
            answer += f"📋 订单总数：{order_count} 单\n"
            answer += f"⭐ 评价总数：{review_count} 条\n"
            answer += f"👤 用户总数：{user_count} 人\n"
            return answer, True
        
        # ==================== 商家申请状态查询 ====================
        if user_id and any(kw in question_lower for kw in ['申请状态', '入驻申请', '审核进度', '我的申请']):
            application = MerchantApplication.query.filter_by(user_id=user_id).order_by(MerchantApplication.created_at.desc()).first()
            if not application:
                return "主人，您还没有提交过商家入驻申请哦~", True
            
            status_map = {'pending': '审核中', 'approved': '已通过', 'rejected': '已拒绝'}
            status = status_map.get(application.status, application.status)
            answer = f"主人，您的商家申请状态：{status}\n"
            if application.status == 'rejected' and application.reject_reason:
                answer += f"拒绝原因：{application.reject_reason}\n"
            return answer, True
        
    except Exception as e:
        print(f"Database query error: {e}")
        import traceback
        traceback.print_exc()
        return f"查询数据库时出错了：{str(e)}", True
    
    return None, False


@ai_assistant_bp.route('/chat', methods=['POST'])
@optional_token_required
def chat_with_assistant():
    """Return a helpful answer based on a small operations knowledge base."""
    payload = request.get_json(silent=True) or {}
    question = (payload.get('question') or '').strip()
    if not question:
        return jsonify({
            'success': False,
            'message': '缺少 question 字段',
        }), 400

    # 获取当前用户ID
    user_id = g.current_user.id if hasattr(g, 'current_user') and g.current_user else None
    
    # 第一步：先尝试数据库查询
    db_answer, is_db_query = query_database(question, user_id)
    if is_db_query and db_answer:
        print(f"DEBUG: Database query successful for '{question}'")
        return jsonify({
            'success': True,
            'data': {
                'answer': db_answer,
                'matched_question': None,
                'score': 1.0,
                'title': '数据库查询结果',
                'source': 'database',
                'user': g.current_user.to_dict() if hasattr(g, 'current_user') and g.current_user else None,
            }
        }), 200

    # 第二步：尝试本地知识库匹配
    result = _find_best_answer(question)
    
    print(f"DEBUG: Question='{question}', Best Local Score={result['score']}")

    # Fallback if similarity is too low
    # 将阈值从 0.4 提高到 0.6，这样更容易触发外部大模型
    threshold = 0.6
    if not result["answer"] or result["score"] < threshold:
        print("DEBUG: Triggering External LLM...")
        # 尝试调用外部大模型 (ModelScope)
        external_answer, error_msg = call_modelscope_llm(question)
        if external_answer:
            return jsonify({
                'success': True,
                'data': {
                    'answer': external_answer,
                    'matched_question': None,
                    'score': 0.0,
                    'title': 'AI 智能回复',
                    'user': g.current_user.to_dict() if hasattr(g, 'current_user') else None,
                }
            }), 200
        else:
            print(f"DEBUG: External LLM returned None. Error: {error_msg}")

        return jsonify({
            'success': True,
            'data': {
                'answer': f'暂未找到匹配的知识点，且外部AI响应失败。错误信息: {error_msg}',
                'matched_question': result.get('matched_question'),
                'score': result.get('score'),
                'title': result.get('title'),
                'user': g.current_user.to_dict() if hasattr(g, 'current_user') else None,
            }
        }), 200

    return jsonify({
        'success': True,
        'data': {
            'answer': result['answer'],
            'matched_question': result['matched_question'],
            'score': result['score'],
            'title': result['title'],
            'source': 'knowledge_base',
            'user': g.current_user.to_dict() if hasattr(g, 'current_user') else None,
        }
    }), 200


@ai_assistant_bp.route('/welcome', methods=['GET'])
@optional_token_required
def get_welcome_message():
    """获取AI助手欢迎信息"""
    welcome_message = """喵~ 主人好呀！我是食刻预约系统的AI小助手 🐱✨

我可以帮您做这些事情：

📋 **订单管理**
• 查看我的订单："我的订单"
• 订单状态查询："订单状态"

🏪 **店铺信息**
• 查看所有店铺："有哪些店铺"
• 查看店铺菜单："XX餐厅有哪些菜"

🍽️ **菜品推荐**
• 热门推荐："推荐什么好吃的"
• 查看评价："最近的评价"

📊 **系统统计**
• 数据统计："系统数据统计"

💡 **系统帮助**
• 操作指南："怎么登录"、"如何注册"

有什么想问的就直接说吧，主人~ 😊"""
    
# 处理用户信息，支持User对象和SimpleNamespace游客对象
    user_info = None
    if hasattr(g, 'current_user'):
        if hasattr(g.current_user, 'to_dict'):
            user_info = g.current_user.to_dict()
        else:
            # 游客用户，手动构建字典
            user_info = {
                'user_id': getattr(g.current_user, 'user_id', None),
                'username': getattr(g.current_user, 'username', '游客'),
                'phone': getattr(g.current_user, 'phone', None),
                'user_type': getattr(g.current_user, 'user_type', 'guest'),
            }
    
    return jsonify({
        'success': True,
        'data': {
            'message': welcome_message,
            'user': user_info,
        }
    }), 200
