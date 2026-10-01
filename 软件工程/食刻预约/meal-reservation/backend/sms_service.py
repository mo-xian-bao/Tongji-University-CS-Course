"""
短信服务模块
提供短信发送和验证功能
"""

import logging
from datetime import datetime, timedelta
from Models import SMSVerification,db
from auxiliary_function import validate_phone
from alibabaSMSSender import AlibabaSMSSender

# 配置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def cleanup_expired_codes():
    """清理过期的验证码"""
    expired_time = datetime.utcnow()
    SMSVerification.query.filter(
        SMSVerification.expires_at < expired_time
    ).delete()
    db.session.commit()


def get_latest_valid_code(phone, purpose):
    """获取指定手机号和用途的最新有效验证码"""
    cleanup_expired_codes()  # 先清理过期验证码

    return SMSVerification.query.filter_by(
        phone=phone,
        purpose=purpose,
        is_used=False
    ).order_by(SMSVerification.created_at.desc()).first()


def can_send_code(phone, purpose, cooldown_minutes=1):
    """检查是否可以发送验证码（防止频繁发送）"""
    cooldown_time = datetime.utcnow() - timedelta(minutes=cooldown_minutes)

    recent_code = SMSVerification.query.filter(
        SMSVerification.phone == phone,
        SMSVerification.purpose == purpose,
        SMSVerification.created_at > cooldown_time
    ).first()

    return recent_code is None

class SMSService:
    """短信服务类"""

    def __init__(self, debug_mode=True):
        # 在实际项目中，这里应该配置短信服务商的API密钥等信息
        self.sms_provider = "mock"  # 模拟短信服务商
        self.debug_mode = debug_mode  # 开发模式下，验证码会打印到控制台

    def send_verification_code(self, phone, purpose='register'):
        """
        发送短信验证码

        Args:
            phone (str): 手机号
            purpose (str): 用途 ('register', 'login', 'reset_password')

        Returns:
            dict: 发送结果
        """
        try:
            # 验证手机号格式
            if not validate_phone(phone):
                return {
                    'success': False,
                    'message': '手机号格式不正确'
                }

            # 检查发送频率限制
            if not can_send_code(phone, purpose, cooldown_minutes=1):
                return {
                    'success': False,
                    'message': '发送过于频繁，请稍后再试'
                }

            # 清理过期验证码
            cleanup_expired_codes()

            # 生成新的验证码记录
            verification = SMSVerification(phone, purpose)
            from app_init import db
            db.session.add(verification)
            db.session.commit()

            # 发送短信
            send_result = self._send_sms(phone, verification.code, purpose)

            if send_result['success']:
                logger.info(f"验证码发送成功 - 手机号: {phone}, 用途: {purpose}, 验证码: {verification.code}")
                return {
                    'success': True,
                    'message': '验证码发送成功',
                    'data': {
                        'expires_in': 300,  # 5分钟有效期
                        'phone': phone[-4:] + '****'  # 脱敏显示
                    }
                }
            else:
                # 发送失败，删除验证码记录
                db.session.delete(verification)
                db.session.commit()
                return send_result

        except Exception as e:
            logger.error(f"发送验证码失败: {str(e)}")
            return {
                'success': False,
                'message': '发送失败，请稍后重试'
            }

    def verify_code(self, phone, code, purpose='register'):
        """
        验证短信验证码

        Args:
            phone (str): 手机号
            code (str): 验证码
            purpose (str): 用途

        Returns:
            dict: 验证结果
        """
        try:
            # 验证手机号格式
            if not validate_phone(phone):
                return {
                    'success': False,
                    'message': '手机号格式不正确'
                }

            # 验证码格式检查
            if not code or len(code) != 6 or not code.isdigit():
                return {
                    'success': False,
                    'message': '验证码格式不正确'
                }

            # 获取最新的有效验证码
            verification = get_latest_valid_code(phone, purpose)

            if not verification:
                return {
                    'success': False,
                    'message': '验证码不存在或已过期'
                }

            # 验证码匹配检查
            if verification.code != code:
                return {
                    'success': False,
                    'message': '验证码错误'
                }

            # 检查是否已使用
            if verification.is_used:
                return {
                    'success': False,
                    'message': '验证码已被使用'
                }

            # 标记为已使用
            verification.mark_as_used()

            logger.info(f"验证码验证成功 - 手机号: {phone}, 用途: {purpose}")
            return {
                'success': True,
                'message': '验证码验证成功'
            }

        except Exception as e:
            logger.error(f"验证码验证失败: {str(e)}")
            return {
                'success': False,
                'message': '验证失败，请稍后重试'
            }

    def _send_sms(self, phone, code, purpose):
        """
        实际发送短信的方法

        Args:
            phone (str): 手机号
            code (str): 验证码
            purpose (str): 用途

        Returns:
            dict: 发送结果
        """
        if self.debug_mode:
            # 开发模式下，只打印到控制台，不实际发送短信
            print("=" * 50)
            print(f"【短信验证码】")
            print(f"手机号: {phone}")
            print(f"用途: {purpose}")
            print(f"验证码: {code}")
            print(f"有效期: 5分钟")
            print("=" * 50)

            return {
                'success': True,
                'message': '模拟发送成功'
            }

        # 生产环境中的实际短信发送逻辑
        # 这里可以集成阿里云短信、腾讯云短信等服务
        try:
            # 示例：调用短信服务商API
            
            sender = AlibabaSMSSender(
                phone_number=phone,
                template_param='{"code":"'+ code + '","min":"5"}',
                template_code=self._get_template(purpose)
            )
            # 发送短信
            sender.send()

            # 模拟成功
            return {
                'success': True,
                'message': '短信发送成功'
            }

        except Exception as e:
            logger.error(f"短信发送失败: {str(e)}")
            return {
                'success': False,
                'message': '短信发送失败'
            }

    def _get_template(self, purpose):
        """根据用途获取短信模板"""
        templates = {
            'register': '100004',
            'login': '100001',
            'reset_password': '100003'
        }
        return templates.get(purpose, templates['register'])


# 创建全局短信服务实例(开发模式)不实际发验证码
sms_service = SMSService()

# 创建全局短信服务实例(应用模式)实际发送验证码
# sms_service = SMSService(debug_mode=False)