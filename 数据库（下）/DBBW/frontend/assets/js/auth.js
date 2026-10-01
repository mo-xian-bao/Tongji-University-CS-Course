// 保存用户认证信息
export function saveAuth(username, token) {
  localStorage.setItem("excourt_user", username);
  if (token) localStorage.setItem("excourt_token", token);
}

// 获取完整认证信息
export function getAuth() {
  const username = localStorage.getItem("excourt_user");
  const token = localStorage.getItem("excourt_token");
  if (!username || !token) return null;
  return { username, token };
}

// 获取用户名
export function getUsername() {
  return localStorage.getItem("excourt_user");
}

// 获取token
export function getToken() {
  return localStorage.getItem("excourt_token");
}

// 清除认证信息
export function clearAuth() {
  localStorage.removeItem("excourt_user");
  localStorage.removeItem("excourt_token");
}

// 检查认证并重定向到登录页
export function requireAuthOrRedirect() {
  const auth = getAuth();
  if (!auth || !auth.username || !auth.token) {
    window.location.href = "/";
    return null;
  }
  return auth.username;
}

// 检查是否已登录
export function isAuthenticated() {
  const auth = getAuth();
  return auth && auth.username && auth.token;
}

