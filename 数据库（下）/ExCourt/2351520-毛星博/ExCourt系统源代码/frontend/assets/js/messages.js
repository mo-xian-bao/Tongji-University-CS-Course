import { getJSON, postJSON, $ } from "./api.js";
import { requireAuthOrRedirect, getAuth } from "./auth.js";

const auth = getAuth();
const token = auth?.token;
const username = auth?.username;
requireAuthOrRedirect();

let currentChatUser = null;
let chatInterval = null;

// 切换标签页
window.switchTab = function(tabName) {
    document.querySelectorAll('.msg-tab').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.msg-tab')[['chats','friends','requests'].indexOf(tabName)].classList.add('active');
    
    $('panel-chats').style.display = tabName === 'chats' ? 'block' : 'none';
    $('panel-friends').style.display = tabName === 'friends' ? 'block' : 'none';
    $('panel-requests').style.display = tabName === 'requests' ? 'block' : 'none';
    
    if(tabName === 'chats') loadConversations();
    if(tabName === 'friends') loadFriends();
    if(tabName === 'requests') loadRequests();
}

// 加载会话列表
async function loadConversations() {
    const list = $('panel-chats');
    try {
        const data = await getJSON('/social/chat/conversations', token);
        if(data.length === 0) {
            list.innerHTML = '<div style="text-align:center; padding:20px; color:#999;">暂无消息</div>';
            return;
        }
        list.innerHTML = data.map(c => `
            <div class="list-item" onclick="openChat('${c.username}')">
                <div class="avatar">👤</div>
                <div class="item-content">
                    <div class="item-title">${c.username}</div>
                    <div class="item-subtitle">${c.last_message}</div>
                </div>
                <div class="item-time">${new Date(c.last_time).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</div>
            </div>
        `).join('');
    } catch(e) { console.error(e); }
}

// 加载好友列表
async function loadFriends() {
    const list = $('friendsList');
    try {
        const data = await getJSON('/social/friends/list', token);
        if(data.length === 0) {
            list.innerHTML = '<div style="text-align:center; padding:20px; color:#999;">暂无好友</div>';
            return;
        }
        list.innerHTML = data.map(f => `
            <div class="list-item">
                <div class="avatar" style="background:#e8f2fb; color:#4a90e2;">F</div>
                <div class="item-content">
                    <div class="item-title">${f.username}</div>
                </div>
                <div style="display:flex; gap:8px;">
                    <button onclick="openChat('${f.username}')" style="padding:6px 12px; border-radius:4px; border:none; background:#4a90e2; color:white;">发消息</button>
                    <button onclick="deleteFriend('${f.username}')" style="padding:6px 12px; border-radius:4px; border:none; background:#e74c3c; color:white;">删除</button>
                </div>
            </div>
        `).join('');
    } catch(e) { console.error(e); }
}

// 加载申请
async function loadRequests() {
    const list = $('requestsList');
    try {
        // 并行获取好友申请和交换申请
        const [friendReqs, exchangeReqs] = await Promise.all([
            getJSON('/social/requests/pending', token),
            getJSON('/exchange/pending', token)
        ]);
        
        let html = '';
        
        // 好友申请
        friendReqs.forEach(r => {
            html += `
                <div class="list-item">
                    <div class="avatar" style="background:#ffebee; color:#d32f2f;">👋</div>
                    <div class="item-content">
                        <div class="item-title">${r.username}</div>
                        <div class="item-subtitle">请求添加好友</div>
                    </div>
                    <button onclick="acceptFriend('${r.username}')" style="background:#4a90e2; color:white; border:none; padding:6px 12px; border-radius:4px;">同意</button>
                </div>
            `;
        });

        // 交换申请
        exchangeReqs.forEach(r => {
            console.log('Exchange request:', r, 'Current user:', username, 'Match:', r.post_user_name === username);
            // 只有我是被请求方(post_user_name)时才显示处理按钮
            if (r.post_user_name === username) {
                // 显示对方出价的积分
                const pointsText = r.offer_points ? `<div style="color: #f59e0b; font-size: 12px; margin-top: 4px;">💰 对方出价: ${r.offer_points} 积分</div>` : '';
                
                html += `
                    <div class="list-item" style="flex-wrap: wrap;">
                        <div class="avatar" style="background:#e8f5e9; color:#2e7d32;">🏟️</div>
                        <div class="item-content">
                            <div class="item-title">场地交换申请</div>
                            <div class="item-subtitle">${r.request_user_name} 想要您的场地 ${r.court_id}</div>
                            ${pointsText}
                            <div class="item-time">${new Date(r.created_at).toLocaleString()}</div>
                        </div>
                        <div style="width: 100%; display: flex; gap: 8px; margin-top: 8px; justify-content: flex-end;">
                            <button onclick="acceptExchange('${r.id}')" style="background:#4a90e2; color:white; border:none; padding:6px 12px; border-radius:4px;">同意</button>
                            <button onclick="rejectExchange('${r.id}')" style="background:#f5f5f5; color:#666; border:1px solid #ddd; padding:6px 12px; border-radius:4px;">拒绝</button>
                        </div>
                    </div>
                `;
            } else {
                // 我是发起方，显示等待状态
                html += `
                    <div class="list-item">
                        <div class="avatar" style="background:#fff3e0; color:#f57c00;">🏟️</div>
                        <div class="item-content">
                            <div class="item-title">我的交换申请</div>
                            <div class="item-subtitle">您申请了 ${r.post_user_name} 的场地 ${r.court_id}</div>
                        </div>
                        <span style="color:#999; font-size:12px;">等待对方处理</span>
                    </div>
                `;
            }
        });

        list.innerHTML = html || '<div style="text-align:center; padding:20px; color:#999;">暂无新申请</div>';
        
        // 更新红点
        const total = friendReqs.length + exchangeReqs.filter(r => r.post_user_name === username).length;
        $('reqBadge').style.display = total > 0 ? 'inline-block' : 'none';
        $('reqBadge').textContent = total;

    } catch(e) { console.error(e); }
}

// --- 聊天功能 ---

window.openChat = function(username) {
    currentChatUser = username;
    $('chatTitle').textContent = username;
    $('chatWindow').classList.add('open');
    loadChatHistory();
    // 轮询新消息
    if(chatInterval) clearInterval(chatInterval);
    chatInterval = setInterval(loadChatHistory, 3000);
}

window.closeChat = function() {
    $('chatWindow').classList.remove('open');
    currentChatUser = null;
    if(chatInterval) clearInterval(chatInterval);
    loadConversations(); // 刷新列表
}

async function loadChatHistory() {
    if(!currentChatUser) return;
    try {
        const msgs = await getJSON(`/social/chat/history?target_user=${currentChatUser}`, token);
        const body = $('chatBody');
        // 简单处理：全量刷新（生产环境应增量更新）
        const wasAtBottom = body.scrollHeight - body.scrollTop === body.clientHeight;
        
        body.innerHTML = msgs.map(m => `
            <div class="msg-bubble ${m.sender === username ? 'msg-sent' : 'msg-received'}">
                ${m.content}
            </div>
        `).join('');
        
        if(wasAtBottom || msgs.length < 10) body.scrollTop = body.scrollHeight;
    } catch(e) { console.error(e); }
}

window.sendMessage = async function() {
    const input = $('chatInput');
    const content = input.value.trim();
    if(!content || !currentChatUser) return;
    
    try {
        await postJSON('/social/chat/send', {
            receiver: currentChatUser,
            content: content
        }, token);
        input.value = '';
        loadChatHistory();
    } catch(e) { alert(e.message); }
}

// 聊天输入框回车发送
document.addEventListener('DOMContentLoaded', () => {
    $('chatInput').addEventListener('keydown', (e) => {
        if(e.key === 'Enter') sendMessage();
    });
});

// --- 辅助功能 ---

window.searchUser = async function() {
    const input = $('addFriendInput');
    const targetUsername = input.value.trim();
    const resultDiv = $('searchResult');
    
    if(!targetUsername) {
        resultDiv.innerHTML = '';
        return;
    }
    
    try {
        const res = await getJSON(`/social/users/search?username=${encodeURIComponent(targetUsername)}`, token);
        if(res.found) {
            resultDiv.innerHTML = `
                <div class="list-item" style="background:#f8f9fb; margin:0 12px 12px; border-radius:8px;">
                    <div class="avatar" style="background:#e8f2fb; color:#4a90e2;">👤</div>
                    <div class="item-content">
                        <div class="item-title">${res.username}</div>
                        <div class="item-subtitle" style="color:#888;">${res.status || '用户'}</div>
                    </div>
                    ${res.is_friend ? `
                        <span style="color:#27ae60; font-size:12px;">已是好友</span>
                    ` : res.pending ? `
                        <span style="color:#f39c12; font-size:12px;">申请中</span>
                    ` : `
                        <button onclick="addFriend('${res.username}')" style="padding:6px 12px; border-radius:4px; border:none; background:#4a90e2; color:white;">添加好友</button>
                    `}
                </div>
            `;
        } else {
            resultDiv.innerHTML = `<div style="text-align:center; padding:12px; color:#999;">未找到用户 "${targetUsername}"</div>`;
        }
    } catch(e) {
        resultDiv.innerHTML = `<div style="text-align:center; padding:12px; color:#e74c3c;">搜索失败</div>`;
    }
}

window.addFriend = async function(targetUsername) {
    try {
        const res = await postJSON('/social/friends/request', {target_username: targetUsername}, token);
        alert(res.message);
        $('addFriendInput').value = '';
        $('searchResult').innerHTML = '';
        loadFriends();
    } catch(e) { alert(e.message); }
}

window.acceptFriend = async function(targetUsername) {
    try {
        await postJSON('/social/friends/accept', {target_username: targetUsername}, token);
        alert('已添加好友');
        loadRequests();
        loadFriends();
    } catch(e) { alert(e.message); }
}

window.deleteFriend = async function(targetUsername) {
    if(!confirm(`确定要删除好友 ${targetUsername} 吗？`)) return;
    try {
        await postJSON('/social/friends/delete', {target_username: targetUsername}, token);
        alert('已删除好友');
        loadFriends();
    } catch(e) { alert(e.message); }
}

window.acceptExchange = async function(reqId) {
    if(confirm('确认同意该场地交换请求吗？')) {
        try {
            const res = await postJSON('/exchange/accept', {request_id: reqId}, token);
            // 使用后端返回的消息（包含积分奖励信息）
            alert(res.message); 
            loadRequests();
        } catch(e) { alert(e.message); }
    }
}

window.rejectExchange = async function(reqId) {
    if(confirm('确认拒绝该场地交换请求吗？')) {
        try {
            await postJSON('/exchange/reject', {request_id: reqId}, token);
            alert('已拒绝');
            loadRequests();
        } catch(e) { alert(e.message); }
    }
}

// --- 加号菜单功能 ---

let selectedCourts = [];

window.togglePlusMenu = function() {
    const menu = $('plusMenu');
    const courtPanel = $('courtSelectPanel');
    const pointsPanel = $('pointsTransferPanel');
    
    if (menu.style.display === 'none') {
        menu.style.display = 'block';
        courtPanel.style.display = 'none';
        pointsPanel.style.display = 'none';
    } else {
        menu.style.display = 'none';
    }
}

window.showGiftCourt = async function() {
    $('plusMenu').style.display = 'none';
    $('courtSelectPanel').style.display = 'block';
    selectedCourts = [];
    
    // 加载我的场地
    try {
        const courts = await getJSON('/courts/owned/mine', token);
        const list = $('myCourtsList');
        
        if (courts.length === 0) {
            list.innerHTML = '<div style="color:#999; text-align:center;">暂无可赠送的场地</div>';
            return;
        }
        
        list.innerHTML = courts.map(c => `
            <label style="display:flex; align-items:center; padding:8px; border:1px solid #eee; border-radius:4px; margin-bottom:4px; cursor:pointer;">
                <input type="checkbox" value="${c.court_id}|${c.start_date}|${c.start_hour}" onchange="toggleCourtSelect(this)" style="margin-right:8px;">
                <span>场地 ${c.court_id} - ${c.start_date} ${c.start_hour}:00-${c.end_hour}:00</span>
            </label>
        `).join('');
    } catch(e) {
        $('myCourtsList').innerHTML = '<div style="color:#e74c3c;">加载失败</div>';
    }
}

window.toggleCourtSelect = function(checkbox) {
    const val = checkbox.value;
    if (checkbox.checked) {
        selectedCourts.push(val);
    } else {
        selectedCourts = selectedCourts.filter(v => v !== val);
    }
}

window.confirmGiftCourts = async function() {
    if (selectedCourts.length === 0) {
        alert('请选择要赠送的场地');
        return;
    }
    
    if (!confirm(`确认将 ${selectedCourts.length} 个场地赠送给 ${currentChatUser} 吗？`)) return;
    
    try {
        for (const courtInfo of selectedCourts) {
            const [courtId, date, startHour] = courtInfo.split('|');
            await postJSON('/exchange/gift', {
                target_user: currentChatUser,
                court_id: parseInt(courtId),
                date: date,
                start_hour: parseInt(startHour)
            }, token);
        }
        alert('赠送成功！');
        cancelGiftCourt();
        // 发送一条消息通知
        await postJSON('/social/chat/send', {
            receiver: currentChatUser,
            content: `[系统消息] 我赠送了 ${selectedCourts.length} 个场地给你`
        }, token);
        loadChatHistory();
    } catch(e) {
        alert('赠送失败：' + e.message);
    }
}

window.cancelGiftCourt = function() {
    $('courtSelectPanel').style.display = 'none';
    selectedCourts = [];
}

window.showTransferPoints = function() {
    $('plusMenu').style.display = 'none';
    $('pointsTransferPanel').style.display = 'block';
    $('transferPointsInput').value = '';
}

window.confirmTransferPoints = async function() {
    const points = parseInt($('transferPointsInput').value);
    if (!points || points <= 0) {
        alert('请输入有效的积分数量');
        return;
    }
    
    if (!confirm(`确认转账 ${points} 积分给 ${currentChatUser} 吗？`)) return;
    
    try {
        await postJSON('/auth/points/transfer', {
            target_user: currentChatUser,
            points: points
        }, token);
        alert('转账成功！');
        cancelTransferPoints();
        // 发送一条消息通知
        await postJSON('/social/chat/send', {
            receiver: currentChatUser,
            content: `[系统消息] 我转账了 ${points} 积分给你`
        }, token);
        loadChatHistory();
    } catch(e) {
        alert('转账失败：' + e.message);
    }
}

window.cancelTransferPoints = function() {
    $('pointsTransferPanel').style.display = 'none';
}

// 初始化
loadConversations();
loadRequests(); // 检查红点

// 检查是否从其他页面跳转过来要打开聊天
const openChatWith = sessionStorage.getItem('openChatWith');
if (openChatWith) {
    sessionStorage.removeItem('openChatWith');
    openChat(openChatWith);
}