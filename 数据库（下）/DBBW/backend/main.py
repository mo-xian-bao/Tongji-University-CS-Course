from contextlib import asynccontextmanager
from database import connect_to_mongo, close_mongo_connection
from config import settings
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware

@asynccontextmanager
async def lifespan(app: FastAPI):
    """应用生命周期管理"""
    # 启动时执行
    print("🚀 启动 FastAPI 应用...")
    await connect_to_mongo()
    yield
    # 关闭时执行
    print("👋 关闭 FastAPI 应用...")
    await close_mongo_connection()

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="ExCourt-易场地交换系统",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# 允许前端跨域访问（开发阶段放开，生产环境请按需收紧）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册路由
from routers.auth import router as auth_router
from routers.courts import router as courts_router
from routers.exchange import router as exchange_router
from routers.admin import router as admin_router
app.include_router(auth_router)
app.include_router(courts_router)
app.include_router(exchange_router)
app.include_router(admin_router)

# 挂载前端资源
app.mount("/frontend", StaticFiles(directory="frontend"), name="frontend")

@app.get("/")
async def root():
    """返回前端首页 HTML"""
    return FileResponse("frontend/pages/index.html")

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.HOST,
        port=settings.PORT,
        reload=True
    )