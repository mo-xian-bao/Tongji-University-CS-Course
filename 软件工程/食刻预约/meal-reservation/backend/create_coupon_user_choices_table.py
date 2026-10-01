"""
创建用户优惠券选择记录表的数据库迁移脚本
"""
from app_init import db
from Models import CouponUserChoice

def create_coupon_user_choices_table():
    """创建coupon_user_choices表"""
    try:
        # 创建表
        with db.engine.begin() as conn:
            CouponUserChoice.__table__.create(conn, checkfirst=True)

        print("✅ 成功创建 coupon_user_choices 表")
        return True
    except Exception as e:
        print(f"❌ 创建表失败: {str(e)}")
        return False

if __name__ == "__main__":
    print("开始创建用户优惠券选择记录表...")
    success = create_coupon_user_choices_table()

    if success:
        print("🎉 数据库迁移完成！")
    else:
        print("💥 数据库迁移失败！")