# 快速开始

配置环境
```bash
# 建议配置虚拟环境
# 使用python 3.11
conda create --name DBBW python=3.11
conda activate DBBW
pip install -r requirements.txt
```

启动docker desktop应用，然后在项目命令行中执行

```bash
# 拉取mongo最新的镜像（若已拉取则不用执行）
docker pull mongo:latest
# 运行容器，启动数据库 
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

运行后端

```bash
# 必须在项目根目录下运行
python backend/main.py
```
项目运行在http://127.0.0.1:8000/

## 后续任务
- [] 美化前端界面
- [] 信息发布的请求与相应增加用户信息
- [] 申请交换功能-resquest respond refuse complete
- [] 好友功能-add delete get