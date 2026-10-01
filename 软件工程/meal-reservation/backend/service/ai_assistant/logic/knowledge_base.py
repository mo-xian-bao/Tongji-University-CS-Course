"""AI assistant knowledge base — static Q&A data + matching logic."""
from difflib import SequenceMatcher
from typing import Dict, List, Tuple

KNOWLEDGE_BASE: List[Dict] = [
    {
        "title": "账号登录与注册",
        "questions": ["怎么登录系统", "如何注册账号", "登录失败怎么办"],
        "answer": (
            "在登录页输入手机号/用户名+密码即可登录；首次使用点击注册，按提示填写必填信息并验证手机。"
            "若忘记密码可使用找回密码流程，通过短信验证码重置。"
        ),
        "keywords": ["登录", "注册", "找回密码", "验证码"],
    },
    {
        "title": "商家入驻",
        "questions": ["怎么提交商家申请", "商户入驻需要什么材料", "商家审核多久"],
        "answer": (
            "在商家中心提交入驻申请，需提供营业执照、法人身份证、门店基本信息和联系方式；"
            '提交后可在「申请记录」查看状态，审核通过后即可创建菜单和管理订单。'
        ),
        "keywords": ["商家", "入驻", "申请", "审核", "营业执照"],
    },
    {
        "title": "菜单与上架",
        "questions": ["如何上架菜品", "菜品图片上传路径", "库存管理"],
        "answer": (
            "进入商家后台-菜单管理，点击新增菜品，填写名称、价格、分类、库存并上传图片；"
            "支持随时下架或调整库存，库存为0时前台会显示售罄。"
        ),
        "keywords": ["菜品", "上架", "菜单", "库存", "图片上传"],
    },
    {
        "title": "订单与桌台",
        "questions": ["如何查看新订单", "桌位管理怎么用", "排队叫号在哪"],
        "answer": (
            "在商家后台-订单队列查看实时订单，支持接单/拒单与状态更新；"
            "桌台管理可新增、编辑、禁用桌位并设置二维码；"
            "排队叫号在订单队列内，可按就餐桌台或取餐号通知用户。"
        ),
        "keywords": ["订单", "桌台", "排队", "叫号", "队列"],
    },
    {
        "title": "通知与短信",
        "questions": ["短信验证码不收到", "推送通知怎么配置", "上新通知"],
        "answer": (
            "验证码发送失败通常是请求过于频繁或号码格式错误，稍后重试；"
            "商家可在通知设置里开启上新/优惠券推送，用户侧需要允许消息权限；"
            "如持续异常请联系管理员检查短信服务和网关配额。"
        ),
        "keywords": ["短信", "验证码", "推送", "通知", "上新"],
    },
    {
        "title": "评价与申诉",
        "questions": ["差评怎么处理", "评价被屏蔽", "如何发起申诉"],
        "answer": (
            "在评价管理中回复或标记异常评价，必要时提交申诉并附证据；"
            "申诉提交后可在申诉列表查看处理进度，平台会在审核后给出结果。"
        ),
        "keywords": ["评价", "申诉", "差评", "回复"],
    },
    {
        "title": "个人信息与安全",
        "questions": ["怎么修改头像", "如何修改密码", "更换手机号"],
        "answer": (
            '在「个人中心-编辑资料」中可以上传新头像、修改昵称；'
            "修改密码或更换手机号需要进行短信验证，以确保账号安全。"
        ),
        "keywords": ["头像", "密码", "手机号", "个人中心", "资料"],
    },
    {
        "title": "优惠券与支付",
        "questions": ["怎么使用优惠券", "支付方式有哪些", "退款怎么操作"],
        "answer": (
            "下单结算时，系统会自动列出可用优惠券，选择即可抵扣；"
            "支持微信、支付宝等主流支付方式；如需退款，请在订单详情页申请，商家审核通过后原路退回。"
        ),
        "keywords": ["优惠券", "支付", "退款", "结算", "抵扣"],
    },
    {
        "title": "搜索与收藏",
        "questions": ["怎么搜索菜品", "如何收藏店铺", "找不到想吃的菜"],
        "answer": (
            "首页顶部搜索栏支持按菜名、商家名搜索；"
            '进入商家主页点击右上角「心形」图标即可收藏，方便下次快速找到。'
        ),
        "keywords": ["搜索", "收藏", "查找", "店铺"],
    },
]


def _score_question(user_question: str, entry: Dict) -> Tuple[float, str]:
    best_question, best_score = "", 0.0
    for q in entry.get("questions", []):
        score = SequenceMatcher(None, user_question, q).ratio()
        if score > best_score:
            best_score, best_question = score, q
    keyword_hits = sum(1 for kw in entry.get("keywords", []) if kw in user_question)
    return best_score + 0.08 * keyword_hits, best_question


def _find_best_answer(user_question: str) -> Dict:
    best_entry, best_score, best_q = None, 0.0, ""
    for entry in KNOWLEDGE_BASE:
        score, matched_q = _score_question(user_question, entry)
        if score > best_score:
            best_score, best_q, best_entry = score, matched_q, entry
    return {
        "score": round(best_score, 3),
        "matched_question": best_q,
        "answer": best_entry.get("answer") if best_entry else None,
        "title": best_entry.get("title") if best_entry else None,
    }
