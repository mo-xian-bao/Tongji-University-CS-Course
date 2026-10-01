// API基础URL，空字符串表示同源
export const API_BASE = "";

// POST请求JSON数据
export async function postJSON(path, data, token = null) {
  const headers = { "Content-Type": "application/json" };
  if (token) headers["Authorization"] = `Bearer ${token}`;

  const res = await fetch(API_BASE + path, {
    method: "POST",
    headers,
    body: JSON.stringify(data)
  });
  const text = await res.text();
  let json;
  try { json = text ? JSON.parse(text) : {}; } catch { json = { detail: text }; }
  if (!res.ok) {
    const err = json?.detail || json?.message || "请求失败";
    throw new Error(err);
  }
  return json;
}

// GET请求
export async function getJSON(path, token = null) {
  const headers = {};
  if (token) headers["Authorization"] = `Bearer ${token}`;

  const res = await fetch(API_BASE + path, {
    method: "GET",
    headers
  });
  const text = await res.text();
  let json;
  try { json = text ? JSON.parse(text) : {}; } catch { json = { detail: text }; }
  if (!res.ok) {
    const err = json?.detail || json?.message || "请求失败";
    throw new Error(err);
  }
  return json;
}

// 简化getElementById
export function $(id) { return document.getElementById(id); }

// 设置消息提示
export function setMessage(text, type) {
  const el = $("message");
  if (!el) return;
  el.textContent = text || "";
  el.className = "message" + (type ? ` ${type}` : "");
}

// 格式化日期
export function formatDate(date) {
  if (!date) return '';
  if (typeof date === 'string') return date;
  const d = new Date(date);
  return d.toISOString().split('T')[0];
}

// 格式化时间
export function formatTime(time) {
  if (!time) return '';
  if (typeof time === 'string') return time.substring(0, 5);
  return time;
}

