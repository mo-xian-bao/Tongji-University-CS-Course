# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Backend (Flask)
```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Start development server (port 5000, debug mode)
python run.py

# Run all tests
pytest tests/ -v

# Run a single test file
pytest tests/test_api.py -v

# Run API surface tests (validates all endpoints respond)
pytest tests/test_api_surface.py -v
```

### Frontend (Vue3 + Vite)
```bash
# Install dependencies (first time)
npm install

# Start dev server (port 3000, proxies /api → localhost:5000)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Architecture Overview

This is a full-stack food booking (点餐/预约) application — Vue3 frontend, Flask backend, SQLite (dev) / MySQL (prod).

### Backend Layered Architecture

The backend follows a strict 4-layer pattern introduced in commit `21b2055`:

```
app/         → Flask Blueprint routes (thin — parse request, call service, return response)
service/     → Business logic handlers (validation, orchestration, JWT token generation)
database/    → Data-access functions (raw CRUD, queries; returns (payload, status_code) tuples)
Models/      → SQLAlchemy ORM model definitions
utils/       → Shared infrastructure (error classes, JWT, SMS, validation, file uploads)
```

**Route layer** (`app/*_routes.py`): Each file defines a Flask Blueprint. Routes are thin — they extract parameters from `request`, call a `service/*/handlers` function, and `jsonify` the result. Example: `app/auth_routes.py` → `service/auth/handlers.py`.

**Service layer** (`service/*/handlers.py`): Business logic. Handlers validate inputs, call `database/` functions, wrap results via `coerce_result()`, and attach JWT tokens. They return `(payload, status_code)` tuples on success. On failure, they raise `ApiError` subclasses (defined in `utils/api_errors.py`).

**Database layer** (`database/*.py`): Direct SQLAlchemy operations. Returns `(payload_dict, status_code)` — status ≥ 400 indicates failure, which `coerce_result()` converts to an `ApiError` exception.

**Models layer** (`Models/*.py`): Declarative ORM models (`User`, `Restaurant`, `Dish`, `Order`, `CouponNotification`, `Review`, `SupportTicket`, etc.). Note: `db` is exported from `Models/user.py` (imported from `app_init`), **not** directly from `app_init`.

Key design rules:
- Routes never contain business logic — only parameter extraction and response formatting.
- Services never touch `request`/Flask globals directly — they receive plain arguments.
- Errors propagate via `ApiError` exceptions (caught by `app/error_handlers.py`). There are 6 subtypes: `BadRequestError`(400), `UnauthorizedError`(401), `ForbiddenError`(403), `NotFoundError`(404), `ConflictError`(409), `BusinessError`(custom status).
- New features must follow the `route → service → database` chain. Do not put logic directly in routes.

### Backend Key Files

| Path | Purpose |
|---|---|
| `backend/app_init.py` | Creates Flask app, SQLAlchemy `db`, CORS config |
| `backend/run.py` | Entry point — creates upload dirs, inits DB, starts server |
| `backend/app/__init__.py` | Imports and registers all Blueprints |
| `backend/app/error_handlers.py` | Central `ApiError` → JSON error response mapping |
| `backend/utils/api_errors.py` | Exception class hierarchy for all API errors |
| `backend/utils/service_result.py` | `ServiceResult` dict + `ok()` helper + `coerce_result()` adapter |
| `backend/utils/auth.py` | `@token_required` / `@optional_token_required` decorators |
| `backend/utils/jwt_utils.py` | JWT creation (`create_jwt`) and decoding (`decode_jwt`) |
| `backend/utils/uploads.py` | Upload folder paths, allowed file types, file deletion helper |
| `backend/Models/__init__.py` | Re-exports all ORM models |

### Current API Modules (Blueprints)

All registered in `app/__init__.py` with `/api` prefix:

- `auth` — register, login (password/SMS), token validation, phone/username check, password reset
- `users` — user CRUD, profile, ban management
- `restaurant` / `restaurants` — restaurant CRUD, search, follows
- `orders` — order creation, status management, change requests
- `tables` — table management and availability
- `dishes` — dish CRUD, stock management, launch notifications
- `coupon` — coupon notifications and user preference tracking
- `merchant` — merchant applications, dashboard, push notifications
- `admin` — admin dashboard, user management, store approval, appeal handling, system notifications
- `appeal` — user appeals for bans
- `support` — support tickets and system notifications
- `ai_assistant` — AI-powered assistant features
- `other` — health check, static file serving

### Frontend Architecture

- **Entry**: `src/main.js` → creates Vue app, mounts router
- **Router**: `src/router/index.js` — hash history, role-based routes (login/register, user, merchant, admin, support)
- **Global components**: `src/App.vue` (shell), `src/components/AIAssistantFloating.vue` (floating AI button)

Page trees by role:
- **User** (`src/user/`): ShopList → Restaurant → Menu → Checkout/OrderForm; Order management; Profile, Coupons, Follows, Appeals, Messages
- **Merchant** (`src/merchant/`): Dashboard, MenuList, OrderQueue, TableManagement, PushNotification, Statistics, StoreInfo, ReviewManagement
- **Admin** (`src/admin/`): Dashboard, AccountBan, StoreApplications, AppealHandling, CommentManagement, SystemNotification
- **Support** (`src/support/`): SupportDashboard, SupportDesk, SupportProcessing, SupportChat

### Data Flow

1. Frontend makes API calls via Axios to `API_url` (injected by Vite `define`, defaults to `http://localhost:5000`)
2. Vite dev server proxies `/api/*` requests to the Flask backend (configured in `vite.config.js`)
3. Backend route extracts request data → calls service handler → service calls database functions → returns JSON
4. Authentication uses JWT in `Authorization: Bearer <token>` header. `@token_required` decorator sets `g.current_user` from the token's `sub` claim
5. All error responses follow the format: `{"success": false, "message": "...", "code": N}`

### Testing

Tests live in `backend/tests/` and use pytest. `conftest.py` sets up `sys.path` so tests can import from the backend package. Key test files:
- `test_api.py` — registration and login scenarios
- `test_api_surface.py` — smoke test that verifies every endpoint returns a response
- `test_coupon_api.py` — coupon-specific tests
- `test_sms_api.py` — SMS verification tests
- `test_integration.py` — end-to-end integration tests

### Environment

- `.env` at project root or `backend/` — `SECRET_KEY` and `DATABASE_URL` (falls back to SQLite `foodbook.db`)
- Upload directories (`static/uploads/` and subdirs) are auto-created by `run.py` on startup
- Windows 11, VS Code, Python 3.10+

### 项目背景

- 团队正在开发基于 Vue + Flask + MySQL 的软件项目。用户是初学者，精通 C++ 和 Python，讲解代码时请以类比 C++/Python 的方式进行。
- 可以考虑使用 Apifox 辅助前后端 API 开发和调试。如有适用场景，请告知如何操作。
