import { postJSON, $, setMessage } from "/frontend/assets/js/api.js";
import { saveAuth } from "/frontend/assets/js/auth.js";

function switchTab(to){
  const isLogin = to === "login";
  $("tab-login").classList.toggle("active", isLogin);
  $("tab-register").classList.toggle("active", !isLogin);
  $("panel-login").classList.toggle("hidden", !isLogin);
  $("panel-register").classList.toggle("hidden", isLogin);
  setMessage("");
}

$("tab-login").addEventListener("click", () => switchTab("login"));
$("tab-register").addEventListener("click", () => switchTab("register"));

$("btn-login").addEventListener("click", async () => {
  const username = $("login-username").value.trim();
  const password = $("login-password").value;
  if(!username || !password){ setMessage("请输入用户名和密码", "error"); return; }
  setMessage("登录中...");
  try {
    const res = await postJSON("/auth/login", {username, password});
    setMessage(res?.message || "登录成功", "success");
    const token = res?.data?.token;
    const isAdmin = res?.data?.is_admin;
    saveAuth(username, token);
    // 根据是否管理员跳转不同页面
    if (isAdmin) {
      window.location.href = "/frontend/pages/admin.html";
    } else {
      window.location.href = "/frontend/pages/dashboard.html";
    }
  } catch(e){
    setMessage(String(e.message || e), "error");
  }
});

$("btn-register").addEventListener("click", async () => {
  const username = $("register-username").value.trim();
  const password = $("register-password").value;
  if(!username || !password){ setMessage("请输入用户名和密码", "error"); return; }
  if(password.length < 6){ setMessage("密码至少6位", "error"); return; }
  setMessage("注册中...");
  try {
    const res = await postJSON("/auth/register", {username, password});
    setMessage(res?.message || "注册成功", "success");
    switchTab("login");
    $("login-username").value = username;
  } catch(e){
    setMessage(String(e.message || e), "error");
  }
});

// 登录面板回车键支持
$("login-username").addEventListener("keydown", (e) => {
  if(e.key === "Enter") $("login-password").focus();
});
$("login-password").addEventListener("keydown", (e) => {
  if(e.key === "Enter") $("btn-login").click();
});

// 注册面板回车键支持
$("register-username").addEventListener("keydown", (e) => {
  if(e.key === "Enter") $("register-password").focus();
});
$("register-password").addEventListener("keydown", (e) => {
  if(e.key === "Enter") $("btn-register").click();
});


