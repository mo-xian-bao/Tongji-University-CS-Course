"""
短信验证码功能测试脚本
测试注册和登录的短信验证码功能
"""

import requests
import json
import time

BASE_URL = "http://localhost:5000/api"

def test_sms_registration():
    """测试短信验证码注册流程"""
    print("=== 测试短信验证码注册流程 ===")

    # 测试手机号
    test_phone = "13800138003"
    test_username = "smstest"
    test_password = "123456"

    # 1. 发送注册验证码
    print("1. 发送注册验证码...")
    response = requests.post(
        f"{BASE_URL}/sms/send",
        json={
            "phone": test_phone,
            "purpose": "register"
        },
        headers={"Content-Type": "application/json"}
    )

    if response.status_code == 200:
        result = response.json()
        print(f"   验证码发送成功: {result['message']}")
        print(f"   手机号: {result['data']['phone']}")
    else:
        print(f"   验证码发送失败: {response.status_code}")
        return

    # 2. 模拟用户查看验证码（在实际应用中，验证码会通过短信发送）
    # 这里我们手动从后端日志获取验证码
    print("\n2. 请查看后端控制台获取验证码，然后按任意键继续...")
    input()

    # 3. 尝试注册（需要手动输入验证码）
    sms_code = input("3. 请输入收到的6位验证码: ")

    print("3. 使用验证码进行注册...")
    response = requests.post(
        f"{BASE_URL}/register",
        json={
            "phone": test_phone,
            "username": test_username,
            "password": test_password,
            "confirmPassword": test_password,
            "smsCode": sms_code
        },
        headers={"Content-Type": "application/json"}
    )

    if response.status_code == 201:
        result = response.json()
        print(f"   注册成功: {result['message']}")
        print(f"   用户ID: {result['data']['user']['id']}")
        print(f"   用户名: {result['data']['user']['username']}")
    else:
        print(f"   注册失败: {response.status_code}")
        print(f"   错误信息: {response.json()}")

def test_sms_login():
    """测试短信验证码登录流程"""
    print("\n=== 测试短信验证码登录流程 ===")

    # 使用已注册的用户测试
    test_phone = "13800138002"

    # 1. 发送登录验证码
    print("1. 发送登录验证码...")
    response = requests.post(
        f"{BASE_URL}/sms/send",
        json={
            "phone": test_phone,
            "purpose": "login"
        },
        headers={"Content-Type": "application/json"}
    )

    if response.status_code == 200:
        result = response.json()
        print(f"   验证码发送成功: {result['message']}")
        print(f"   手机号: {result['data']['phone']}")
    else:
        print(f"   验证码发送失败: {response.status_code}")
        print(f"   错误信息: {response.json()}")
        return

    # 2. 获取验证码
    print("\n2. 请查看后端控制台获取验证码，然后按任意键继续...")
    input()

    sms_code = input("3. 请输入收到的6位验证码: ")

    # 3. 使用验证码登录
    print("3. 使用验证码进行登录...")
    response = requests.post(
        f"{BASE_URL}/login",
        json={
            "identifier": test_phone,
            "smsCode": sms_code,
            "loginType": "sms"
        },
        headers={"Content-Type": "application/json"}
    )

    if response.status_code == 200:
        result = response.json()
        print(f"   登录成功: {result['message']}")
        print(f"   登录方式: {result['data']['login_type']}")
        print(f"   用户Token: {result['data']['token']}")
        print(f"   用户信息: {result['data']['user']['username']}")
    else:
        print(f"   登录失败: {response.status_code}")
        print(f"   错误信息: {response.json()}")

def test_password_login():
    """测试传统密码登录"""
    print("\n=== 测试传统密码登录 ===")

    response = requests.post(
        f"{BASE_URL}/login",
        json={
            "identifier": "admin",
            "password": "123456",
            "loginType": "password"
        },
        headers={"Content-Type": "application/json"}
    )

    if response.status_code == 200:
        result = response.json()
        print(f"   密码登录成功: {result['message']}")
        print(f"   登录方式: {result['data']['login_type']}")
        print(f"   用户信息: {result['data']['user']['username']}")
    else:
        print(f"   密码登录失败: {response.status_code}")
        print(f"   错误信息: {response.json()}")

def test_error_cases():
    """测试错误情况"""
    print("\n=== 测试错误情况 ===")

    # 1. 无效手机号
    print("1. 测试无效手机号...")
    response = requests.post(
        f"{BASE_URL}/sms/send",
        json={
            "phone": "12345678901",
            "purpose": "register"
        },
        headers={"Content-Type": "application/json"}
    )
    result = response.json()
    print(f"   结果: {result['message']}")

    # 2. 发送频率限制
    print("\n2. 测试发送频率限制...")
    response = requests.post(
        f"{BASE_URL}/sms/send",
        json={
            "phone": "13800138000",
            "purpose": "register"
        },
        headers={"Content-Type": "application/json"}
    )
    result = response.json()
    print(f"   结果: {result['message']}")

    # 3. 错误验证码
    print("\n3. 测试错误验证码...")
    response = requests.post(
        f"{BASE_URL}/login",
        json={
            "identifier": "13800138002",
            "smsCode": "123456",
            "loginType": "sms"
        },
        headers={"Content-Type": "application/json"}
    )
    result = response.json()
    print(f"   结果: {result['message']}")

    # 4. 不存在的用户发送登录验证码
    print("\n4. 测试不存在用户发送登录验证码...")
    response = requests.post(
        f"{BASE_URL}/sms/send",
        json={
            "phone": "19999999999",
            "purpose": "login"
        },
        headers={"Content-Type": "application/json"}
    )
    result = response.json()
    print(f"   结果: {result['message']}")

if __name__ == "__main__":
    print("开始测试FoodBook短信验证码功能...")
    print("=" * 50)

    try:
        # 测试各种功能
        test_sms_registration()
        test_sms_login()
        test_password_login()
        test_error_cases()

        print("\n" + "=" * 50)
        print("测试完成！")

    except requests.exceptions.ConnectionError:
        print("错误: 无法连接到后端服务")
        print("请确保后端服务正在运行: python run.py")
    except Exception as e:
        print(f"测试过程中发生错误: {str(e)}")