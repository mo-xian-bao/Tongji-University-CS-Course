"""Admin service handlers — orchestration layer."""
from datetime import datetime

from Models import db
from utils import ApiError, BusinessError, ok

from .logic import reviews, merchant, keywords, bans, appeals, notifications, statistics


# ── reviews ──────────────────────────────────────────────────────────

def list_reviews(current_user, page=1, per_page=50):
    try:
        page, per_page = int(page), int(per_page)
        total, items = reviews.list_paginated(page, per_page)
        return ok({"success": True, "data": {"reviews": [r.to_dict() for r in items], "total": total}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取失败", 500, {"error": str(exc)})


def update_review(current_user, review_id, data):
    try:
        rv = reviews.get_or_404(review_id)
        if "status" in data:
            reviews.apply_status_change(rv, data["status"])
        if "merchant_reply" in data:
            reviews.apply_merchant_reply(rv, data["merchant_reply"])
        if "review_status" in data:
            reviews.apply_review_status(
                rv, data["review_status"],
                data.get("review_reject_reason"), current_user.id
            )
        rv.updated_at = datetime.utcnow()
        db.session.commit()
        reviews.recalc_restaurant_rating(rv.restaurant_id)
        return ok({"success": True, "message": "更新成功", "data": rv.to_dict()}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("更新失败", 500, {"error": str(exc)})


# ── merchant applications ────────────────────────────────────────────

def list_merchant_applications(current_user, status=None, page=1, per_page=20):
    try:
        result = merchant.fetch_applications(status, int(page), int(per_page))
        apps = [merchant.enrich_with_user(app) for app in result["applications"]]
        return ok({
            "success": True, "message": "获取申请列表成功",
            "data": {
                "applications": apps,
                "pagination": {"total": result["total"], "page": result["page"],
                               "per_page": result["per_page"], "pages": result["pages"]},
            },
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取申请列表失败", 500, {"error": str(exc)})


def get_merchant_application_detail(current_user, application_id):
    try:
        app = merchant.fetch_application(application_id)
        return ok({"success": True, "message": "获取申请详情成功",
                    "data": merchant.enrich_detail_with_user(app)}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取申请详情失败", 500, {"error": str(exc)})


def approve_application(current_user, application_id):
    try:
        msg = merchant.approve(application_id, current_user.id)
        return ok({"success": True, "message": msg}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("批准申请失败", 500, {"error": str(exc)})


def reject_application(current_user, application_id, reason):
    try:
        msg = merchant.reject(application_id, current_user.id, reason)
        return ok({"success": True, "message": msg}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("拒绝申请失败", 500, {"error": str(exc)})


def cleanup_user_applications(current_user, application_id):
    try:
        deleted = merchant.cleanup_for_application(application_id)
        return ok({"success": True, "message": f"已清理该用户的 {deleted} 条申请记录"}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("清理申请记录失败", 500, {"error": str(exc)})


# ── review keywords / stats ──────────────────────────────────────────

def reviews_stats(current_user):
    keywords.require_admin(current_user)
    try:
        return ok({"success": True, "data": keywords.compute_review_stats()}, 200)
    except ApiError:
        raise
    except Exception as exc:
        keywords.admin_logger.error(f"获取评论统计失败: {exc}", exc_info=True)
        return {"success": False, "message": "获取评论统计失败", "error": str(exc)}, 500


def list_review_keywords(current_user):
    keywords.require_admin(current_user)
    return ok({"success": True, "data": {"keywords": keywords.list_all_keywords()}}, 200)


def add_review_keyword(current_user, keyword):
    keywords.require_admin(current_user)
    rk, err = keywords.add_keyword(keyword, current_user.id)
    if err:
        return {"success": False, "message": err}, 400
    return ok({"success": True, "message": "添加成功", "data": rk.to_dict()}, 201)


def delete_review_keyword(current_user, kw_id):
    keywords.require_admin(current_user)
    ok_flag = keywords.remove_keyword(kw_id)
    if not ok_flag:
        return {"success": False, "message": "关键词未找到"}, 404
    return ok({"success": True, "message": "删除成功"}, 200)


# ── user bans ────────────────────────────────────────────────────────

def ban_stats(current_user):
    bans.require_admin(current_user)
    try:
        return ok({"success": True, "data": bans.compute_ban_stats()}, 200)
    except Exception as exc:
        return {"success": False, "message": f"获取统计信息失败: {str(exc)}"}, 500


def ban_users_list(current_user, search="", status_filter="all", type_filter="all", page=1, per_page=50):
    bans.require_admin(current_user)
    try:
        pagination = bans.search_users(search, type_filter, int(page), int(per_page))
        users_data = []
        for user in pagination.items:
            user_data = user.to_dict()
            ban_info = bans.find_active_ban(user.id)
            user_data.update({
                "banReason": ban_info.get_reason_text() if ban_info else None,
                "banUntil": ban_info.ban_until.isoformat() if (ban_info and ban_info.ban_until) else None,
            })
            users_data.append(user_data)
        return ok({
            "success": True,
            "data": {"users": users_data, "total": pagination.total,
                     "page": page, "per_page": per_page, "total_pages": pagination.pages},
        }, 200)
    except Exception as exc:
        return {"success": False, "message": f"获取用户列表失败: {str(exc)}"}, 500


def ban_user_op(current_user, user_id, ban_type="permanently", reason="", description="", duration=7, notify=True):
    bans.require_admin(current_user)
    try:
        if not reason:
            return {"success": False, "message": "请选择封禁原因"}, 400
        user = bans.get_user_or_none(user_id)
        if not user:
            return {"success": False, "message": "用户不存在"}, 404
        active = bans.find_active_ban(user_id)
        if active and active.status in ["banned", "temporarily_banned"]:
            return {"success": False, "message": "用户已被封禁，请先解封"}, 400
        record = bans.create_ban(user_id, ban_type, reason, description, duration, current_user.id, notify)
        return ok({"success": True, "message": f"用户 {user.username} 已成功封禁", "data": record.to_dict()}, 200)
    except Exception as exc:
        db.session.rollback()
        return {"success": False, "message": f"封禁用户失败: {str(exc)}"}, 500


def unban_user_op(current_user, user_id):
    bans.require_admin(current_user)
    try:
        user = bans.get_user_or_none(user_id)
        if not user:
            return {"success": False, "message": "用户不存在"}, 404
        ok_flag, err = bans.unban(user_id)
        if not ok_flag:
            return {"success": False, "message": err}, 400
        return ok({"success": True, "message": f"用户 {user.username} 已成功解封"}, 200)
    except Exception as exc:
        db.session.rollback()
        return {"success": False, "message": f"解封用户失败: {str(exc)}"}, 500


def ban_history(current_user, user_id):
    bans.require_admin(current_user)
    try:
        history = bans.get_ban_history(user_id)
        return ok({"success": True, "data": {"user_id": user_id, "ban_history": [b.to_dict() for b in history]}}, 200)
    except Exception as exc:
        return {"success": False, "message": f"获取封禁历史失败: {str(exc)}"}, 500


# ── appeals ──────────────────────────────────────────────────────────

def list_appeals(current_user, status="", page=1, per_page=20):
    appeals.require_admin(current_user)
    try:
        data, pagination = appeals.fetch_appeals(status, int(page), int(per_page))
        return ok({
            "success": True, "message": "获取申诉列表成功",
            "data": {
                "appeals": data,
                "pagination": {"current_page": pagination.page, "total_pages": pagination.pages,
                               "per_page": pagination.per_page, "total_items": pagination.total,
                               "has_next": pagination.has_next, "has_prev": pagination.has_prev},
            },
        }, 200)
    except Exception as exc:
        return {"success": False, "message": f"获取申诉列表失败: {str(exc)}"}, 500


def process_appeal(current_user, appeal_id, action, admin_note=""):
    appeals.require_admin(current_user)
    try:
        result, msg = appeals.process(appeal_id, action, current_user.id, admin_note)
        if result is None:
            return {"success": False, "message": msg}, 400
        return ok({"success": True, "message": msg, "data": result.to_dict()}, 200)
    except Exception as exc:
        db.session.rollback()
        return {"success": False, "message": f"处理申诉失败: {str(exc)}"}, 500


# ── statistics ───────────────────────────────────────────────────────

def merchant_applications_stats(current_user):
    statistics.require_admin(current_user)
    try:
        return ok({"success": True, "message": "获取统计数据成功",
                    "data": statistics.compute_merchant_app_stats()}, 200)
    except Exception as exc:
        return {"success": False, "message": f"获取统计数据失败: {str(exc)}"}, 500


def appeals_stats(current_user):
    statistics.require_admin(current_user)
    try:
        return ok({"success": True, "message": "获取统计数据成功",
                    "data": statistics.compute_appeal_stats()}, 200)
    except Exception as exc:
        return {"success": False, "message": f"获取统计数据失败: {str(exc)}"}, 500


# ── system notifications ─────────────────────────────────────────────

def list_system_notifications(current_user):
    notifications.require_admin(current_user)
    try:
        return ok({"success": True, "data": notifications.fetch_all()}, 200)
    except Exception as exc:
        notifications.admin_logger.error(f"获取系统公告失败: {str(exc)}")
        return {"success": False, "message": "获取系统公告失败"}, 500


def create_system_notification(current_user, content, target_audience="all"):
    notifications.require_admin(current_user)
    try:
        ok_flag, err = notifications.publish(current_user.id, content, target_audience)
        if not ok_flag:
            return {"success": False, "message": err}, 400
        return ok({"success": True, "message": "公告发布成功"}, 201)
    except Exception as exc:
        db.session.rollback()
        notifications.admin_logger.error(f"创建系统公告失败: {str(exc)}")
        return {"success": False, "message": "发布公告失败"}, 500


def delete_system_notification_message(current_user, admin_id, target_audience, timestamp):
    notifications.require_admin(current_user)
    if current_user.id != admin_id and current_user.usertype != 0:
        return {"success": False, "message": "无权限删除他人的公告"}, 403
    try:
        ok_flag, err = notifications.remove_message(admin_id, target_audience, timestamp)
        if not ok_flag:
            return {"success": False, "message": err}, 404
        return ok({"success": True, "message": "消息已删除"}, 200)
    except Exception as exc:
        db.session.rollback()
        notifications.admin_logger.error(f"删除系统公告消息失败: {str(exc)}")
        return {"success": False, "message": "删除消息失败"}, 500


def delete_system_notification(current_user, admin_id, target_audience):
    notifications.require_admin(current_user)
    try:
        ok_flag, err = notifications.remove_all(current_user.id, admin_id, target_audience)
        if not ok_flag:
            return {"success": False, "message": err}, 404 if "不存在" in (err or "") else 403
        return ok({"success": True, "message": "公告已删除"}, 200)
    except Exception as exc:
        db.session.rollback()
        notifications.admin_logger.error(f"删除系统公告失败: {str(exc)}")
        return {"success": False, "message": "删除公告失败"}, 500


