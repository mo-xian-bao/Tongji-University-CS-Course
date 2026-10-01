/**
 * 自定义弹窗组件
 * 替代原生 alert/confirm
 */

// 创建弹窗容器
function createDialogContainer() {
    if (document.getElementById('customDialog')) return;
    
    const dialog = document.createElement('div');
    dialog.id = 'customDialog';
    dialog.className = 'custom-dialog';
    dialog.innerHTML = `
        <div class="dialog-box">
            <div class="dialog-icon" id="dialogIcon">✓</div>
            <div class="dialog-title" id="dialogTitle">提示</div>
            <div class="dialog-message" id="dialogMessage">消息内容</div>
            <div class="dialog-buttons" id="dialogButtons"></div>
        </div>
    `;
    document.body.appendChild(dialog);
}

// 显示弹窗
function showDialog(options) {
    createDialogContainer();
    
    const dialog = document.getElementById('customDialog');
    const iconEl = document.getElementById('dialogIcon');
    const titleEl = document.getElementById('dialogTitle');
    const messageEl = document.getElementById('dialogMessage');
    const buttonsEl = document.getElementById('dialogButtons');
    
    // 图标映射
    const icons = {
        success: '✓',
        error: '✕',
        warning: '⚠',
        info: 'ℹ',
        confirm: '?'
    };
    
    const type = options.type || 'info';
    iconEl.textContent = icons[type] || icons.info;
    iconEl.className = `dialog-icon ${type}`;
    
    titleEl.textContent = options.title || '提示';
    messageEl.textContent = options.message || '';
    
    // 清空按钮
    buttonsEl.innerHTML = '';
    
    return new Promise((resolve) => {
        if (options.buttons) {
            options.buttons.forEach(btn => {
                const button = document.createElement('button');
                button.textContent = btn.text;
                button.className = btn.class || 'dialog-btn-primary';
                button.onclick = () => {
                    dialog.classList.remove('open');
                    resolve(btn.value);
                };
                buttonsEl.appendChild(button);
            });
        } else {
            // 默认确定按钮
            const okBtn = document.createElement('button');
            okBtn.textContent = '确定';
            okBtn.className = 'dialog-btn-primary';
            okBtn.onclick = () => {
                dialog.classList.remove('open');
                resolve(true);
            };
            buttonsEl.appendChild(okBtn);
        }
        
        dialog.classList.add('open');
    });
}

// 提示框（替代 alert）
export async function showAlert(message, type = 'info') {
    let title = '提示';
    if (type === 'success') title = '成功';
    else if (type === 'error') title = '错误';
    else if (type === 'warning') title = '警告';
    
    return showDialog({
        type,
        title,
        message,
        buttons: [{ text: '确定', class: 'dialog-btn-primary', value: true }]
    });
}

// 确认框（替代 confirm）
export async function showConfirm(message, options = {}) {
    return showDialog({
        type: options.type || 'confirm',
        title: options.title || '确认',
        message,
        buttons: [
            { text: options.cancelText || '取消', class: 'dialog-btn-secondary', value: false },
            { text: options.confirmText || '确定', class: options.confirmClass || 'dialog-btn-primary', value: true }
        ]
    });
}

// 成功提示
export async function showSuccess(message) {
    return showAlert(message, 'success');
}

// 错误提示
export async function showError(message) {
    return showAlert(message, 'error');
}

// 警告提示
export async function showWarning(message) {
    return showAlert(message, 'warning');
}

// 危险确认（删除等操作）
export async function showDangerConfirm(message, options = {}) {
    return showDialog({
        type: 'warning',
        title: options.title || '确认操作',
        message,
        buttons: [
            { text: options.cancelText || '取消', class: 'dialog-btn-secondary', value: false },
            { text: options.confirmText || '确定删除', class: 'dialog-btn-danger', value: true }
        ]
    });
}
