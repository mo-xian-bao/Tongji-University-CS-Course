"""Merchant application CRUD."""
from datetime import datetime

from Models import MerchantApplication, db
from utils import BadRequestError, ForbiddenError, NotFoundError, ok
from utils.uploads import delete_file_by_url


def _extract_fields(content_type, form_data, json_data):
    if content_type and "multipart/form-data" in content_type:
        return (
            form_data.get("shopName", ""),
            form_data.get("shopType", ""),
            form_data.get("businessLicense", ""),
            form_data.get("phone", ""),
            form_data.get("address", ""),
            form_data.get("businessHours", ""),
            form_data.get("description", ""),
            form_data.get("status", "draft"),
            form_data.get("licenseFile", ""),
            form_data.get("idFile", ""),
        )
    data = json_data or {}
    if not data:
        raise BadRequestError("缺少请求数据")
    return (
        data.get("shopName", ""),
        data.get("shopType", ""),
        data.get("businessLicense", ""),
        data.get("phone", ""),
        data.get("address", ""),
        data.get("businessHours", ""),
        data.get("description", ""),
        data.get("status", "draft"),
        data.get("licenseFile"),
        data.get("idFile"),
    )


def list_or_create(method, content_type, form_data, json_data, current_user):
    if method == "GET":
        applications = MerchantApplication.get_by_user(current_user.id)
        return ok({
            "success": True,
            "message": "获取申请列表成功",
            "data": {"applications": [app.to_dict() for app in applications]},
        }, 200)

    shop_name, shop_type, business_license, phone, address, business_hours, description, status, license_file_url, id_file_url = _extract_fields(
        content_type, form_data, json_data
    )

    application = MerchantApplication(
        user_id=current_user.id,
        shop_name=shop_name,
        shop_type=shop_type,
        business_license=business_license,
        phone=phone,
        address=address,
        business_hours=business_hours,
        description=description,
        status=status,
        license_file_url=license_file_url,
        id_file_url=id_file_url,
    )
    db.session.add(application)
    return ok({"success": True, "message": "申请提交成功", "data": application.to_dict()}, 201)


def get_or_update(method, content_type, form_data, json_data, current_user, application_id):
    application = MerchantApplication.query.get(application_id)
    if not application:
        raise NotFoundError("申请不存在")
    if application.user_id != current_user.id:
        raise ForbiddenError("无权访问该申请")

    if method == "GET":
        return ok({"success": True, "data": application.to_dict()}, 200)

    shop_name, shop_type, business_license, phone, address, business_hours, description, status, license_file_url, id_file_url = _extract_fields(
        content_type, form_data, json_data
    )

    application.shop_name = shop_name
    application.shop_type = shop_type
    application.business_license = business_license
    application.phone = phone
    application.address = address
    application.business_hours = business_hours
    application.description = description
    application.status = status
    delete_file_by_url(application.license_file_url)
    delete_file_by_url(application.id_file_url)
    application.license_file_url = license_file_url
    application.id_file_url = id_file_url
    application.updated_at = datetime.utcnow()
    return ok({"success": True, "message": "申请更新成功", "data": application.to_dict()}, 200)
