from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # 应用配置
    APP_NAME: str = "DBBW"
    APP_VERSION: str = "1.0.0"

    # 服务器配置
    HOST: str = "127.0.0.1"
    PORT: int = 8000

    # 数据库配置
    MONGODB_URL: str = "mongodb://localhost:27017"
    DATABASE_NAME: str = "ExCourt"

    # 鉴权配置
    JWT_SECRET: str = "dev-secret-change-me"
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRE_MINUTES: int = 120
    
settings = Settings()