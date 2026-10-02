# -*- coding: utf-8 -*-
import os
import sys

from typing import List

from alibabacloud_dypnsapi20170525.client import Client as Dypnsapi20170525Client
from alibabacloud_credentials.client import Client as CredentialClient
from alibabacloud_credentials.models import Config as CredentialConfig
from alibabacloud_tea_openapi import models as open_api_models
from alibabacloud_dypnsapi20170525 import models as dypnsapi_20170525_models
from alibabacloud_tea_util import models as util_models
from alibabacloud_tea_console.client import Client as ConsoleClient
from alibabacloud_tea_util.client import Client as UtilClient


# 服务账号定义
"""
模板代码：
100001:
您的验证码为${code}。尊敬的客户，以上验证码${min}分钟内有效，请注意保密，切勿告知他人。
100002:
尊敬的客户，您正在进行修改手机号操作，您的验证码为${code}。以上验证码${min}分钟内有效，请注意保密，切勿告知他人。
100003:
尊敬的客户，您正在进行重置密码操作，您的验证码为${code}。以上验证码${min}分钟内有效，请注意保密，切勿告知他人。
100004:
尊敬的客户，您正在进行绑定手机号操作，您的验证码为${code}。以上验证码${min}分钟内有效，请注意保密，切勿告知他人。
100005:
尊敬的客户，您正在验证绑定手机号操作，您的验证码为${code}。以上验证码${min}分钟内有效，请注意保密，切勿告知他人。  	
"""


class AlibabaSMSSender:
    def __init__(self, phone_number: str = None,
                 template_param: str = None,
                 template_code: str = None):
        """
        初始化短信发送器

        @param phone_number: 手机号码
        @param template_param: 模板参数: 类似'{"code":"123456","min":"1"}'的形式
        @param template_code: 模板代码: [100001, 100002, 100003, 100004, 100005]
        """
        self.phone_number = phone_number
        self.template_param = template_param
        self.template_code = template_code
        self.sign_name = '速通互联验证码'
        self.client = self._create_client()

    def _create_client(self) -> Dypnsapi20170525Client:
        """
        使用凭据初始化账号Client
        @return: Client
        @throws Exception
        """
        # 从环境变量获取AK信息
        access_key_id = os.getenv("ALIBABA_CLOUD_ACCESS_KEY_ID", "")
        access_key_secret = os.getenv("ALIBABA_CLOUD_ACCESS_KEY_SECRET", "")
        if not access_key_id or not access_key_secret:
            raise ValueError("请设置 ALIBABA_CLOUD_ACCESS_KEY_ID 和 ALIBABA_CLOUD_ACCESS_KEY_SECRET 环境变量")

        credentialsConfig = CredentialConfig(
            type='access_key',
            access_key_id=access_key_id,
            access_key_secret=access_key_secret
        )

        credential = CredentialClient(credentialsConfig)
        config = open_api_models.Config(
            credential=credential
        )
        # Endpoint 请参考 https://api.aliyun.com/product/Dypnsapi
        config.endpoint = f'dypnsapi.aliyuncs.com'
        return Dypnsapi20170525Client(config)

    def send(self, phone_number: str = None,
             template_param: str = None,
             template_code: str = None) -> None:
        """
        发送短信验证码

        @param phone_number: 手机号码(可选，默认使用实例化时的号码)
        @param template_param: 模板参数(可选，默认使用实例化时的参数)
        @param template_code: 模板代码(可选，默认使用实例化时的代码)
        """
        # 使用传入参数或默认参数
        phone = phone_number or self.phone_number
        param = template_param or self.template_param
        code = template_code or self.template_code
        sign = self.sign_name

        if not phone or not param or not code or not sign:
            raise ValueError("缺少必要参数，请提供手机号、模板参数、模板代码和短信签名")

        send_sms_verify_code_request = dypnsapi_20170525_models.SendSmsVerifyCodeRequest(
            sign_name=sign,
            phone_number=phone,
            template_param=param,
            template_code=code
        )
        runtime = util_models.RuntimeOptions()
        try:
            resp = self.client.send_sms_verify_code_with_options(send_sms_verify_code_request, runtime)
            ConsoleClient.log(UtilClient.to_jsonstring(resp))
        except Exception as error:
            # 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            # 错误 message
            print(error.message)
            # 诊断地址
            print(error.data.get("Recommend"))
            UtilClient.assert_as_string(error.message)

    async def send_async(self, phone_number: str = None,
                         template_param: str = None,
                         template_code: str = None) -> None:
        """
        异步发送短信验证码

        @param phone_number: 手机号码(可选，默认使用实例化时的号码)
        @param template_param: 模板参数(可选，默认使用实例化时的参数)
        @param template_code: 模板代码(可选，默认使用实例化时的代码)
        """
        # 使用传入参数或默认参数
        phone = phone_number or self.phone_number
        param = template_param or self.template_param
        code = template_code or self.template_code
        sign = self.sign_name

        if not phone or not param or not code or not sign:
            raise ValueError("缺少必要参数，请提供手机号、模板参数、模板代码和短信签名")

        send_sms_verify_code_request = dypnsapi_20170525_models.SendSmsVerifyCodeRequest(
            sign_name=sign,
            phone_number=phone,
            template_param=param,
            template_code=code
        )
        runtime = util_models.RuntimeOptions()
        try:
            resp = await self.client.send_sms_verify_code_with_options_async(send_sms_verify_code_request, runtime)
            ConsoleClient.log(UtilClient.to_jsonstring(resp))
        except Exception as error:
            # 此处仅做打印展示，请谨慎对待异常处理，在工程项目中切勿直接忽略异常。
            # 错误 message
            print(error.message)
            # 诊断地址
            print(error.data.get("Recommend"))
            UtilClient.assert_as_string(error.message)


# 使用示例
if __name__ == '__main__':
    sender = AlibabaSMSSender(
        phone_number='13548614728',
        template_param='{"code":"123456","min":"1"}',
        template_code='100005'
    )

    # 发送短信
    sender.send()
