"""Database queries for AI assistant — answers user questions by querying the DB."""
from typing import Optional, Tuple

from Models import Dish, MerchantApplication, Order, Restaurant, Review, User


def _query_database(question: str, user_id: Optional[int] = None) -> Tuple[str, bool]:
    """Returns (answer, is_db_query)."""
    q = question.lower()
    try:
        # ── welcome / help ──
        if any(kw in q for kw in ["你好", "在吗", "你是谁", "帮助", "能做什么", "怎么用", "功能", "help", "你会什么"]):
            return (
                """喵~ 主人好呀！我是食刻预约系统的AI小助手 🐱✨\n\n我可以帮您做这些事情：\n\n📋 **订单管理**\n• 查看我的订单："我的订单"\n• 订单状态查询："订单状态"\n\n🏪 **店铺信息**\n• 查看所有店铺："有哪些店铺"\n• 查看店铺菜单："XX餐厅有哪些菜"\n\n🍽️ **菜品推荐**\n• 热门推荐："推荐什么好吃的"\n• 查看评价："最近的评价"\n\n📊 **系统统计**\n• 数据统计："系统数据统计"\n\n💡 **系统帮助**\n• 操作指南："怎么登录"、"如何注册"\n• 商家入驻："如何入驻商家"\n\n有什么想问的就直接说吧，主人~ 😊""",
                True,
            )

        # ── orders ──
        if any(kw in q for kw in ["订单", "我的订单", "订单状态", "订单记录", "点了什么"]):
            if not user_id:
                return "请先登录后查询订单信息哦~", True
            orders = Order.query.filter_by(user_id=user_id).order_by(Order.created_at.desc()).limit(5).all()
            if not orders:
                return "您还没有任何订单记录哦~", True
            status_map = {"pending": "待接单", "confirmed": "已确认", "preparing": "准备中", "ready": "已完成", "completed": "已完成", "cancelled": "已取消"}
            lines = [f"主人，您最近有{len(orders)}个订单："]
            for i, o in enumerate(orders, 1):
                r = Restaurant.query.get(o.restaurant_id)
                lines.append(f"{i}. {r.name if r else '未知商家'} - ¥{o.total_price} - {status_map.get(o.status, o.status)}")
            return "\n".join(lines), True

        # ── restaurants ──
        if any(kw in q for kw in ["商家", "餐厅", "店铺", "有哪些店", "哪些餐厅", "店家"]):
            rs = Restaurant.query.limit(10).all()
            if not rs:
                return "暂时还没有商家信息哦~", True
            lines = [f"主人，目前有{len(rs)}家店铺："]
            for i, r in enumerate(rs, 1):
                lines.append(f"{i}. 【{r.name}】- {r.address or '暂无地址'}")
            return "\n".join(lines), True

        # ── dishes of a specific restaurant ──
        if any(kw in q for kw in ["有哪些菜", "有什么菜", "菜单", "菜品有哪些", "都有什么菜", "卖什么"]):
            all_rs = Restaurant.query.all()
            target = next((r for r in all_rs if r.name and r.name in question), None)
            if target:
                dishes = Dish.query.filter_by(restaurant_id=target.id).order_by(Dish.monthly_sales.desc()).all()
                if not dishes:
                    return f"主人，【{target.name}】暂时还没有上架菜品哦~", True
                lines = [f"主人，【{target.name}】有{len(dishes)}道菜品："]
                for i, d in enumerate(dishes, 1):
                    stock = f" (库存:{d.stock_quantity})" if d.stock_quantity is not None else ""
                    sales = f" (月售{d.monthly_sales})" if d.monthly_sales and d.monthly_sales > 0 else ""
                    lines.append(f"{i}. {d.name} - ¥{d.price}{stock}{sales}")
                return "\n".join(lines), True
            names = "、".join([r.name for r in all_rs[:5]])
            return (f"主人，请告诉我您想查看哪家店铺的菜品哦~ 目前有：{names} 等店铺" if names else "主人，请告诉我您想查看哪家店铺的菜品哦~"), True

        # ── hot dishes ──
        if any(kw in q for kw in ["热门菜", "推荐菜", "什么好吃", "菜品推荐", "推荐", "好吃的"]):
            dishes = Dish.query.order_by(Dish.monthly_sales.desc()).limit(8).all()
            if not dishes:
                return "暂时没有菜品信息哦~", True
            lines = ["主人，这些菜品超受欢迎呢："]
            for i, d in enumerate(dishes, 1):
                r = Restaurant.query.get(d.restaurant_id)
                lines.append(f"{i}. 【{d.name}】- ¥{d.price} - {r.name if r else '未知商家'} (月售{d.monthly_sales or 0})")
            return "\n".join(lines), True

        # ── reviews ──
        if any(kw in q for kw in ["评价", "评论", "好评", "差评", "口碑"]):
            reviews = Review.query.filter_by(review_status="approved").order_by(Review.created_at.desc()).limit(5).all()
            if not reviews:
                return "暂时还没有评价信息哦~", True
            lines = ["主人，这是最新的一些评价："]
            for i, rv in enumerate(reviews, 1):
                r = Restaurant.query.get(rv.restaurant_id)
                stars = "⭐" * (rv.rating if rv.rating else 0)
                txt = (rv.content[:25] + "...") if rv.content and len(rv.content) > 25 else (rv.content or "无内容")
                lines.append(f"{i}. 【{r.name if r else '未知商家'}】{stars} - {txt}")
            return "\n".join(lines), True

        # ── stats ──
        if any(kw in q for kw in ["多少家店", "统计", "数据", "总共", "一共"]):
            return (
                f"主人，这是系统的统计数据：\n"
                f"🏪 商家总数：{Restaurant.query.count()} 家\n"
                f"🍽️ 菜品总数：{Dish.query.count()} 道\n"
                f"📋 订单总数：{Order.query.count()} 单\n"
                f"⭐ 评价总数：{Review.query.count()} 条\n"
                f"👤 用户总数：{User.query.count()} 人\n"
            ), True

        # ── merchant application status ──
        if user_id and any(kw in q for kw in ["申请状态", "入驻申请", "审核进度", "我的申请"]):
            app = MerchantApplication.query.filter_by(user_id=user_id).order_by(MerchantApplication.created_at.desc()).first()
            if not app:
                return "主人，您还没有提交过商家入驻申请哦~", True
            m = {"pending": "审核中", "approved": "已通过", "rejected": "已拒绝"}
            answer = f"主人，您的商家申请状态：{m.get(app.status, app.status)}"
            if app.status == "rejected" and app.reject_reason:
                answer += f"\n拒绝原因：{app.reject_reason}"
            return answer, True
    except Exception as exc:
        print(f"数据库查询出错: {exc}")
        return f"查询数据库时出错了：{str(exc)}", True
    return "", False
