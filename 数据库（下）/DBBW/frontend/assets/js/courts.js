import { $, postJSON, setMessage } from "/frontend/assets/js/api.js";
import { requireAuthOrRedirect, getToken } from "/frontend/assets/js/auth.js";

function isoDate(v){ return v; } // input type=date gives YYYY-MM-DD
function isoTime(v){ return v.length === 5 ? v + ":00" : v; } // ensure HH:MM:SS

async function postWithAuth(path, data){
  const token = getToken();
  const res = await fetch(path, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    },
    body: JSON.stringify(data)
  });
  const text = await res.text();
  let json; try{ json = text ? JSON.parse(text) : {}; } catch{ json = {detail: text}; }
  if(!res.ok){ throw new Error(json?.detail || json?.message || "请求失败"); }
  return json;
}

function bindOwnedForm(){
  $("owned-submit").addEventListener("click", async () => {
    requireAuthOrRedirect();
    const court_id = parseInt($("owned-court-id").value, 10);
    const start_date = isoDate($("owned-start-date").value);
    const start_time = isoTime($("owned-start-time").value);
    const end_time = isoTime($("owned-end-time").value);
    if(!court_id || !start_date || !start_time || !end_time){ setMessage("请完整填写已有场地表单", "error"); return; }
    setMessage("提交中...");
    try{
      const res = await postWithAuth("/courts/owned/post", { court_id, start_date, start_time, end_time });
      setMessage(res?.message || "提交成功", "success");
    }catch(e){ setMessage(String(e.message||e), "error"); }
  });
}

function bindWantedForm(){
  $("wanted-submit").addEventListener("click", async () => {
    requireAuthOrRedirect();
    const court_id = parseInt($("wanted-court-id").value, 10);
    const start_date = isoDate($("wanted-start-date").value);
    const start_time = isoTime($("wanted-start-time").value);
    const end_time = isoTime($("wanted-end-time").value);
    if(!court_id || !start_date || !start_time || !end_time){ setMessage("请完整填写需求场地表单", "error"); return; }
    setMessage("提交中...");
    try{
      const res = await postWithAuth("/courts/wanted/post", { court_id, start_date, start_time, end_time });
      setMessage(res?.message || "提交成功", "success");
    }catch(e){ setMessage(String(e.message||e), "error"); }
  });
}

bindOwnedForm();
bindWantedForm();

function renderList(el, items){
  if(!el) return;
  if(!items || items.length === 0){ el.innerHTML = "<div class=\"muted\">暂无数据</div>"; return; }
  const rows = items.map(it => `
    <div class="card" style="padding:10px;margin-top:8px">
      <div>场地ID：${it.court_id}</div>
      <div>日期：${it.start_date}</div>
      <div>开始：${it.start_time}，结束：${it.end_time}</div>
    </div>
  `).join("");
  el.innerHTML = rows;
}

function toOptionalInt(v){ const n = parseInt(v,10); return Number.isFinite(n) ? n : undefined; }

function bindOwnedSearch(){
  $("owned-search").addEventListener("click", async () => {
    const payload = {};
    const cid = toOptionalInt($("owned-q-court-id").value);
    if(cid !== undefined) payload.court_id = cid;
    const d = $("owned-q-date").value; if(d) payload.start_date = d;
    const s = $("owned-q-start").value; if(s) payload.start_time = isoTime(s);
    const e = $("owned-q-end").value; if(e) payload.end_time = isoTime(e);
    try{
      const res = await postJSON("/courts/owned/search", payload);
      renderList($("owned-results"), res);
    }catch(err){ setMessage(String(err.message||err), "error"); }
  });
}

function bindWantedSearch(){
  $("wanted-search").addEventListener("click", async () => {
    const payload = {};
    const cid = toOptionalInt($("wanted-q-court-id").value);
    if(cid !== undefined) payload.court_id = cid;
    const d = $("wanted-q-date").value; if(d) payload.start_date = d;
    const s = $("wanted-q-start").value; if(s) payload.start_time = isoTime(s);
    const e = $("wanted-q-end").value; if(e) payload.end_time = isoTime(e);
    try{
      const res = await postJSON("/courts/wanted/search", payload);
      renderList($("wanted-results"), res);
    }catch(err){ setMessage(String(err.message||err), "error"); }
  });
}

bindOwnedSearch();
bindWantedSearch();

