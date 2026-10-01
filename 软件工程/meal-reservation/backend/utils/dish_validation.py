"""Dish validation and formatting helpers."""


def validate_dish_name(name):
    """验证菜品名称"""
    if not name or len(name.strip()) == 0:
        return False, "菜品名称不能为空"
    if len(name) > 100:
        return False, "菜品名称长度不能超过100个字符"
    return True, "菜品名称有效"


def validate_dish_price(price):
    """验证菜品价格"""
    try:
        price_float = float(price)
        if price_float < 0:
            return False, "价格不能为负数"
        if price_float > 999999.99:
            return False, "价格不能超过999999.99"
        return True, "价格有效"
    except (ValueError, TypeError):
        return False, "价格必须是有效的数字"


def validate_dish_category(category):
    """验证菜品分类"""
    if not category:
        return True, "分类可以为空"  # 允许空分类
    if len(category) > 50:
        return False, "分类长度不能超过50个字符"
    return True, "分类有效"


def validate_dish_status(status):
    """验证菜品状态"""
    valid_statuses = ['available', 'sold_out', 'unavailable']
    if status not in valid_statuses:
        return False, f"状态必须是以下之一: {', '.join(valid_statuses)}"
    return True, "状态有效"


def validate_dish_image_url(image_url):
    """验证菜品图片URL"""
    if not image_url:
        return True, "图片URL可以为空"  # 允许空URL
    if len(image_url) > 255:
        return False, "图片URL长度不能超过255个字符"
    return True, "图片URL有效"


def validate_dish_stock_quantity(stock_quantity):
    """验证库存数量"""
    if stock_quantity is None:
        return True, "库存可以为空"  # 允许空库存
    try:
        stock_int = int(stock_quantity)
        if stock_int < 0:
            return False, "库存不能为负数"
        return True, "库存有效"
    except (ValueError, TypeError):
        return False, "库存必须是有效的整数"


def validate_dish_stock_capacity(stock_capacity):
    """验证库存最大容量（stock_capacity）"""
    # 允许为空
    if stock_capacity is None or stock_capacity == '':
        return True, "库存上限可以为空"
    try:
        cap = int(stock_capacity)
        if cap < 0:
            return False, "库存最大容量不能为负数"
        return True, "库存最大容量有效"
    except (ValueError, TypeError):
        return False, "库存最大容量必须是有效的整数"


def validate_stock_alert(stock_alert_enabled, stock_alert_threshold, stock_quantity=None):
    """验证库存预警设置"""
    if not stock_alert_enabled:
        return True, "库存预警未启用"

    if stock_alert_threshold is None:
        return False, "启用库存预警时必须设置预警阈值"

    try:
        threshold = int(stock_alert_threshold)
        if threshold < 0:
            return False, "预警阈值不能为负数"

        # 如果提供了库存数量，验证阈值不应大于库存上限
        if stock_quantity is not None:
            stock = int(stock_quantity)
            if threshold > stock:
                return False, "预警阈值不应大于当前库存"

        return True, "库存预警设置有效"
    except (ValueError, TypeError):
        return False, "预警阈值必须是有效的整数"


def validate_specifications(specifications, multi_spec_enabled=False):
    specs = specifications if isinstance(specifications, list) else []
    if not multi_spec_enabled:
        return True, "规格未启用"
    if not specs:
        return False, "启用多规格时必须提供规格"
    for spec in specs:
        if not isinstance(spec, dict):
            return False, "规格格式不正确"
        name = str(spec.get('name', '')).strip()
        if not name:
            return False, "规格名称不能为空"
        options = spec.get('options') if isinstance(spec.get('options'), list) else []
        if not options:
            return False, f"{name} 规格至少需要一个选项"
        for opt in options:
            if not isinstance(opt, dict):
                return False, "规格选项格式不正确"
            opt_name = str(opt.get('name', '')).strip()
            if not opt_name:
                return False, "规格选项名称不能为空"
            try:
                float(opt.get('price', 0))
            except (TypeError, ValueError):
                return False, f"{name} 规格选项价格必须是数字"
    return True, "规格有效"


def validate_dish_data(data):
    """验证完整菜品数据"""
    errors = []

    # 验证菜品名称
    name_valid, name_msg = validate_dish_name(data.get('name'))
    if not name_valid:
        errors.append(name_msg)

    # 验证价格
    price_valid, price_msg = validate_dish_price(data.get('price'))
    if not price_valid:
        errors.append(price_msg)

    # 验证原价（可选）
    if data.get('original_price'):
        try:
            orig_price = float(data.get('original_price'))
            if orig_price < 0:
                errors.append("原价不能为负数")
            elif orig_price > 999999.99:
                errors.append("原价不能超过999999.99")
        except (ValueError, TypeError):
            errors.append("原价必须是有效的数字")

    # 验证分类
    category_valid, category_msg = validate_dish_category(data.get('category'))
    if not category_valid:
        errors.append(category_msg)

    # 验证状态
    status_valid, status_msg = validate_dish_status(data.get('status'))
    if not status_valid:
        errors.append(status_msg)

    # 验证图片URL
    image_url_valid, image_url_msg = validate_dish_image_url(data.get('image_url'))
    if not image_url_valid:
        errors.append(image_url_msg)

    # 验证库存数量
    stock_valid, stock_msg = validate_dish_stock_quantity(data.get('stock_quantity'))
    if not stock_valid:
        errors.append(stock_msg)

    # 验证库存最大容量
    capacity_valid, capacity_msg = validate_dish_stock_capacity(data.get('stock_capacity'))
    if not capacity_valid:
        errors.append(capacity_msg)

    multi_spec_enabled = bool(data.get('multi_spec_enabled', False))
    specs_valid, specs_msg = validate_specifications(data.get('specifications'), multi_spec_enabled)
    if not specs_valid:
        errors.append(specs_msg)

    # 验证库存预警
    stock_alert_enabled = bool(data.get('stock_alert_enabled', False))
    stock_alert_threshold = data.get('stock_alert_threshold')
    stock_quantity = data.get('stock_quantity')
    alert_valid, alert_msg = validate_stock_alert(stock_alert_enabled, stock_alert_threshold, stock_quantity)
    if not alert_valid:
        errors.append(alert_msg)

    # 验证折扣设置
    discount_enabled = bool(data.get('discount_enabled', False))
    if discount_enabled:
        discount_method = data.get('discount_method')
        if discount_method not in ['price', 'percentage']:
            errors.append("折扣方式必须是 'price' 或 'percentage'")

        if discount_method == 'price':
            discount_price = data.get('discount_price')
            if discount_price is None:
                errors.append("启用定额折扣时必须设置折扣价格")
            else:
                try:
                    val = float(discount_price)
                    if val < 0:
                        errors.append("折扣价格不能为负数")
                except (ValueError, TypeError):
                    errors.append("折扣价格必须是有效的数字")
        elif discount_method == 'percentage':
            discount_percentage = data.get('discount_percentage')
            if discount_percentage is None:
                errors.append("启用比例折扣时必须设置折扣百分比")
            else:
                try:
                    val = float(discount_percentage)
                    if val < 0 or val > 1:
                        errors.append("折扣百分比必须在0到1之间")
                except (ValueError, TypeError):
                    errors.append("折扣百分比必须是有效的数字")

    if errors:
        return False, errors
    return True, "菜品数据验证通过"


def format_dish_data(data):
    """格式化菜品数据"""
    formatted = {}

    # 必填字段
    formatted['restaurant_id'] = int(data.get('restaurant_id'))
    formatted['name'] = data.get('name', '').strip()
    formatted['description'] = data.get('description', '').strip()

    # 价格转换为Decimal
    try:
        formatted['price'] = float(data.get('price', 0))
    except (ValueError, TypeError):
        formatted['price'] = 0.0

    # 原价
    try:
        if data.get('original_price'):
            formatted['original_price'] = float(data.get('original_price'))
        else:
            formatted['original_price'] = None
    except (ValueError, TypeError):
        formatted['original_price'] = None

    # 可选字段
    formatted['category'] = data.get('category', '').strip() or None
    formatted['status'] = data.get('status', 'available')
    try:
        formatted['image_url'] = data.get('image_url', '').strip() or None
    except AttributeError:
        formatted['image_url'] = None
    formatted['stock_quantity'] = data.get('stock_quantity')
    # 格式化库存上限（stock_capacity）
    try:
        if data.get('stock_capacity') is not None and data.get('stock_capacity') != '':
            formatted['stock_capacity'] = int(data.get('stock_capacity'))
        else:
            formatted['stock_capacity'] = None
    except (ValueError, TypeError):
        formatted['stock_capacity'] = None

    # 新增字段
    formatted['is_spicy_selectable'] = bool(data.get('is_spicy_selectable', False))
    formatted['is_garnish_selectable'] = bool(data.get('is_garnish_selectable', False))
    formatted_specs = format_specifications(data.get('specifications', []))
    formatted['specifications'] = formatted_specs
    formatted['multi_spec_enabled'] = bool(data.get('multi_spec_enabled', False) and formatted_specs)

    # 库存预警字段
    formatted['stock_alert_enabled'] = bool(data.get('stock_alert_enabled', False))
    if formatted['stock_alert_enabled']:
        try:
            formatted['stock_alert_threshold'] = int(data.get('stock_alert_threshold', 0))
        except (ValueError, TypeError):
            formatted['stock_alert_threshold'] = None
    else:
        formatted['stock_alert_threshold'] = None

    # 折扣设置字段
    formatted['discount_enabled'] = bool(data.get('discount_enabled', False))
    formatted['discount_method'] = data.get('discount_method', 'price')

    formatted['discount_price'] = None
    formatted['discount_percentage'] = None

    if formatted['discount_enabled']:
        if formatted['discount_method'] == 'price':
            try:
                formatted['discount_price'] = float(data.get('discount_price', 0))
            except (ValueError, TypeError):
                formatted['discount_price'] = None
        elif formatted['discount_method'] == 'percentage':
            try:
                formatted['discount_percentage'] = float(data.get('discount_percentage', 0))
            except (ValueError, TypeError):
                formatted['discount_percentage'] = None

    return formatted


def format_specifications(specifications):
    formatted_specs = []
    if not isinstance(specifications, list):
        return formatted_specs
    for spec in specifications:
        if not isinstance(spec, dict):
            continue
        name = str(spec.get('name', '')).strip()
        if not name:
            continue
        options = []
        for opt in spec.get('options', []):
            if not isinstance(opt, dict):
                continue
            opt_name = str(opt.get('name', '')).strip()
            if not opt_name:
                continue
            try:
                price = float(opt.get('price', 0))
            except (TypeError, ValueError):
                price = 0.0
            option_payload = {'name': opt_name, 'price': price}
            if opt.get('id'):
                option_payload['id'] = opt.get('id')
            options.append(option_payload)
        if options:
            spec_payload = {'name': name, 'options': options}
            if spec.get('id'):
                spec_payload['id'] = spec.get('id')
            formatted_specs.append(spec_payload)
    return formatted_specs
