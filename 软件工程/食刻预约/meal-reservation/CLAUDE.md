# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Backend Development
```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Start Flask development server
python run.py

# Run API tests
python test_api.py
```

### Frontend Development
```bash
# Install dependencies (first time)
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

### Testing API Endpoints
The backend includes a test script that validates both registration and login APIs:
```bash
cd backend
python test_api.py
```

## Architecture Overview

This is a full-stack food booking application with a Vue3 frontend and Flask backend API.

### Frontend Architecture (Vue3 + Vite)
- **Entry Point**: `src/main.js` - Creates Vue app instance and mounts router
- **Root Component**: `src/App.vue` - Provides router-view container and global styles
- **Routing**: `src/router/index.js` - Defines login and register routes with hash history
- **Components**:
  - `src/components/Login.vue` - Login form with phone/username support
  - `src/components/Register.vue` - Registration with comprehensive validation

### Backend Architecture (Flask + SQLAlchemy)
- **Main Application**: `backend/app.py` - Contains Flask app setup, user model, and API routes
- **User Model**: SQLAlchemy model with phone, username, and password_hash fields
- **Authentication**: Werkzeug password hashing with salt
- **Database**: SQLite with `foodbook.db` file
- **API Endpoints**:
  - `POST /api/register` - User registration with validation
  - `POST /api/login` - User authentication
  - `GET /api/health` - Health check endpoint

### Data Flow
1. Frontend components make API calls to `localhost:5000`
2. Flask backend validates requests using regex patterns for phone numbers
3. User passwords are hashed using Werkzeug's security functions
4. Database operations use SQLAlchemy ORM with proper session management
5. CORS is enabled for frontend-backend communication

### Key Configuration
- **Frontend**: Port 3000, auto-open browser, Vue 3 Composition API
- **Backend**: Port 5000, debug mode, SQLite database
- **Environment Variables**: `SECRET_KEY` and `DATABASE_URL` (fallback to SQLite)

### Development Workflow
1. Start backend server first on port 5000
2. Start frontend development server on port 3000
3. Frontend automatically proxies API requests to backend
4. Use browser dev tools to inspect API responses
5. Backend logs all requests and database operations

### Testing Setup
- Pre-configured test account: phone 13800138000, username admin, password 123456
- API test script validates both successful and failed scenarios
- Database resets between tests using SQLAlchemy transactions

### 项目背景
- 我们团队现在正在着手于开发一个软件项目，基于Vue + flask + Mysql,我是一个初学者，所以需要在提供代码时为我讲解其中的原理、语法。我精通C++、python，所以讲解时尽量一类比的方式进行。
- 目前我们还考虑使用APIfox来简化API请求的处理,辅助我们前后端开发，但是我们之前从未使用过APIfox，所以不知道什么时候使用它比较合适,所以在提供代码时如果可以使用apifox辅助开发，请告诉我如何使用它。

### 开发环境
- 开发是在Windows 11系统下进行的，使用的IDE是VS code，请在提供代码时考虑到这一点。