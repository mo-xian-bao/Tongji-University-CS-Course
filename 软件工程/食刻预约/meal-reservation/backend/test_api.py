"""
API测试脚本
用于测试登录和注册接口
"""

import requests
import json

BASE_URL = "http://localhost:5000/api"

def test_health():
    """测试健康检查接口"""
    print("=== 测试健康检查接口 ===")
    try:
        response = requests.get(f"{BASE_URL}/health")
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")
    print()

def test_register():
    """测试注册接口"""
    print("=== 测试注册接口 ===")

    # 测试数据
    test_data = {
        "phone": "13800138001",
        "username": "testuser",
        "password": "123456",
        "confirmPassword": "123456"
    }

    try:
        response = requests.post(
            f"{BASE_URL}/register",
            json=test_data,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")
    print()

def test_login():
    """测试登录接口"""
    print("=== 测试登录接口 ===")

    # 测试手机号登录
    login_data_phone = {
        "identifier": "13800138000",
        "password": "123456"
    }

    print("手机号登录测试:")
    try:
        response = requests.post(
            f"{BASE_URL}/login",
            json=login_data_phone,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")

    print()

    # 测试用户名登录
    login_data_username = {
        "identifier": "admin",
        "password": "123456"
    }

    print("用户名登录测试:")
    try:
        response = requests.post(
            f"{BASE_URL}/login",
            json=login_data_username,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")
    print()

def test_invalid_register():
    """测试无效注册数据"""
    print("=== 测试无效注册数据 ===")

    # 测试无效手机号
    invalid_data1 = {
        "phone": "12345678901",
        "username": "testuser2",
        "password": "123456",
        "confirmPassword": "123456"
    }

    print("无效手机号测试:")
    try:
        response = requests.post(
            f"{BASE_URL}/register",
            json=invalid_data1,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")

    print()

    # 测试密码不匹配
    invalid_data2 = {
        "phone": "13800138002",
        "username": "testuser3",
        "password": "123456",
        "confirmPassword": "654321"
    }

    print("密码不匹配测试:")
    try:
        response = requests.post(
            f"{BASE_URL}/register",
            json=invalid_data2,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")
    print()

def test_invalid_login():
    """测试无效登录数据"""
    print("=== 测试无效登录数据 ===")

    # 测试不存在的用户
    invalid_data1 = {
        "identifier": "nonexistent",
        "password": "123456"
    }

    print("不存在用户测试:")
    try:
        response = requests.post(
            f"{BASE_URL}/login",
            json=invalid_data1,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")

    print()

    # 测试错误密码
    invalid_data2 = {
        "identifier": "admin",
        "password": "wrongpassword"
    }

    print("错误密码测试:")
    try:
        response = requests.post(
            f"{BASE_URL}/login",
            json=invalid_data2,
            headers={"Content-Type": "application/json"}
        )
        print(f"状态码: {response.status_code}")
        print(f"响应: {response.json()}")
    except Exception as e:
        print(f"请求失败: {e}")
    print()

if __name__ == "__main__":
    print("开始测试FoodBook API...")
    print("=" * 50)

    test_health()
    test_register()
    test_login()
    test_invalid_register()
    test_invalid_login()

    print("测试完成！")