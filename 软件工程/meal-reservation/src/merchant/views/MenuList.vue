<template>
  <div class="menu-page">
    <!-- 库存预警提示 -->
    <div v-if="stockAlerts.length > 0" class="stock-alerts-container">
      <div v-for="alert in stockAlerts" :key="alert.alertKey" class="stock-alert-item">
        <div class="alert-icon">⚠️</div>
        <div class="alert-content">
          <div class="alert-title">库存预警</div>
          <div class="alert-message">
            <strong>{{ alert.name }}</strong> 库存已低于设定数 <strong>{{ alert.threshold }}</strong>，
            当前库存：<strong>{{ alert.current }}</strong>
          </div>
        </div>
        <button class="alert-close" @click="dismissAlert(alert.alertKey)" title="关闭提醒">
          ×
        </button>
      </div>
    </div>

    <main class="menu-content">
      <section class="filters-panel">
        <div class="filters-row">
          <div class="search-box">
            <svg viewBox="0 0 24 24" class="icon-search">
              <circle cx="11" cy="11" r="7" stroke-width="2" stroke="currentColor" fill="none" />
              <path d="M20 20l-3.5-3.5" stroke-width="2" stroke="currentColor" fill="none" />
            </svg>
            <input
              v-model="keyword"
              type="text"
              placeholder="搜索菜品名称、分类..."
            />
          </div>
          <div class="filters-actions">
            <button class="ghost-btn" :disabled="!selectedIds.length" @click="batchToggleStatus('available')">
              批量上架
            </button>
            <button class="primary-btn" @click="openAddDish">+ 新增菜品</button>
          </div>
        </div>

        <div class="chips-group">
          <span class="chip-label">分类：</span>
          <button
            v-for="cat in categoryOptions"
            :key="cat"
            class="chip"
            :class="{ active: activeCategory === cat }"
            @click="activeCategory = cat"
          >
            {{ cat }}
          </button>
        </div>

        <div class="chips-group">
          <span class="chip-label">状态：</span>
          <button
            v-for="state in statusOptions"
            :key="state"
            class="chip"
            :class="{ active: activeStatus === state }"
            @click="activeStatus = state"
          >
            {{ state }}
          </button>
        </div>
      </section>

      <section class="dishes-section">
        <div v-if="isLoading" class="empty-state">
          <p>菜单加载中...</p>
        </div>
        <div v-else-if="!filteredDishes.length" class="empty-state">
          <img src="https://via.placeholder.com/420x220?text=%E5%BD%93%E5%89%8D%E6%97%A0%E8%8F%9C%E5%93%81" alt="empty" />
          <p>当前筛选条件暂无菜品</p>
          <button class="primary-btn" @click="openAddDish">新增菜品</button>
        </div>

        <div v-else class="dishes-grid">
          <article
            v-for="dish in filteredDishes"
            :key="dish.id"
            class="dish-card"
            :class="{ selected: selectedIds.includes(dish.id) }"
            @mouseenter="hoverId = dish.id"
            @mouseleave="hoverId = null"
          >
            <div class="card-media">
              <img :src="getImageUrl(dish.image)" :alt="dish.name" />
              <div class="media-overlay">
                <span v-if="dish.tags.includes('推荐')" class="badge badge-hot">推荐</span>
                <span v-if="dish.tags.includes('新品')" class="badge badge-new">新品</span>
              </div>
              <button class="select-toggle" @click.stop="toggleSelect(dish.id)">
                <span v-if="selectedIds.includes(dish.id)">✔</span>
                <span v-else>□</span>
              </button>
            </div>

            <div class="card-body">
              <div class="title-row">
                <h3>{{ dish.name }}</h3>
                <span class="category-pill">{{ dish.category }}</span>
              </div>

              <div class="price-row">
                <span class="price">
                  ¥ {{ dish.price.toFixed(2) }}
                </span>
              </div>

              <div class="meta-row">
                <span class="stock" :class="{ warning: stockRatio(dish) < 0.1 }">
                  库存 {{ dish.stock.current }} / {{ dish.stock.cap }}
                </span>
                <span class="sales">月售 {{ dish.monthlySales }}</span>
              </div>

              <div class="status-row">
                <span class="status-chip success" v-if="dish.status === 'available'">上架</span>
                <span class="status-chip outline" v-else>下架</span>
              </div>
            </div>

            <div class="card-actions">
              <button
                :class="dish.status === 'unavailable' ? 'primary-btn' : 'danger-btn'"
                @click="toggleStatus(dish)"
              >
                {{ dish.status === 'unavailable' ? '上架' : '下架' }}
              </button>

              <button
                v-if="dish.status === 'unavailable'"
                class="warning-btn"
                type="button"
                @click="openOffShelfInfo(dish)"
              >
                下架原因
              </button>
              <button v-else class="ghost-btn" type="button" @click="openSpecs(dish)">规格</button>

              <button class="ghost-btn" @click="editDish(dish)">编辑</button>
            </div>
          </article>
        </div>
      </section>
    </main>

    <div v-if="showEditor" class="dish-editor-mask">
      <div class="editor-shell">
        <header class="editor-top">
          <div class="editor-title">
            <h2>编辑菜品信息</h2>
            <p>调整后将实时同步到前台小程序与自助点餐端。</p>
          </div>
          <button class="editor-close" @click="closeEditor">×</button>
        </header>
        <div class="editor-separator"></div>
        <div class="editor-tabs-bar" role="tablist">
          <button
            v-for="tab in editorTabs"
            :key="tab.value"
            class="editor-tab-btn"
            :class="{ active: editorTab === tab.value }"
            @click="editorTab = tab.value"
            type="button"
            role="tab"
          >
            {{ tab.label }}
          </button>
        </div>

        <section class="editor-panel" v-if="editorTab === 'basic'">
          <div class="form-group">
            <label class="form-field required">
              <div class="field-top">
                <span class="field-label">菜品名称</span>
                <span class="required-star">*</span>
              </div>
              <input v-model="editorForm.name" placeholder="番茄肉饼饭" />
            </label>

            <label class="form-field required">
              <div class="field-top">
                <span class="field-label">菜品分类</span>
                <span class="required-star">*</span>
              </div>
              <div class="category-select-stack">
                <div v-if="!isAddingCategory" class="category-select-row">
                  <select
                    v-model="editorForm.category"
                    :class="{ placeholder: !editorForm.category }"
                    @change="handleCategoryChange($event.target.value)"
                  >
                    <option disabled value="">请选择分类</option>
                    <option
                      v-for="option in renderedCategorySelectOptions"
                      :key="option.value"
                      :value="option.value"
                      :disabled="option.disabled"
                    >
                      {{ option.label }}
                    </option>
                  </select>
                  <button
                    type="button"
                    class="category-create-btn"
                    :disabled="isAddingCategory"
                    @click="startAddCategory"
                    aria-label="新建分类"
                  >
                    <span class="icon-plus" aria-hidden="true"></span>
                  </button>
                </div>
                <div v-else class="category-create-inline">
                  <input
                    ref="newCategoryInput"
                    v-model="newCategoryName"
                    maxlength="12"
                    placeholder="输入新的分类名称"
                  />
                  <button type="button" class="primary-ghost-btn" @click="confirmNewCategory">确定</button>
                  <button type="button" class="ghost-outline-btn" @click="cancelNewCategory">取消</button>
                </div>
              </div>
            </label>
          </div>

          <label class="form-field">
            <span class="field-label">菜品描述</span>
            <textarea
              v-model="editorForm.description"
              rows="4"
              placeholder="请输入菜品描述"
            />
          </label>

          <div class="media-upload-section">
            <div class="media-upload-block">
              <label class="media-label">
                <div class="field-top">
                  <span class="field-label">菜品图片</span>
                  <span class="required-star">*</span>
                </div>
                <span class="upload-hint">建议上传16:9比例的图片，支持 JPG、PNG 格式，单张不超过5M</span>
              </label>


              <div class="media-uploader single-uploader" 
                   :class="{ 'dragging': isDragging }"
                   @click.prevent="triggerImageUpload"
                   @dragenter.prevent="isDragging = true"
                   @dragleave.prevent="isDragging = false"
                   @dragover.prevent="isDragging = true"
                   @drop.prevent="handleDrop">
                <template v-if="editorForm.image">
                  <img class="uploader-preview" :src="getImageUrl(editorForm.image)" alt="菜品图片" />
                  <button class="media-remove" type="button" @click.stop="removeImage">×</button>
                  <div class="media-tag">主图</div>
                </template>
                <template v-else>
                  <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M12 3v10" stroke="#9CA3AF" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M8 7l4-4 4 4" stroke="#9CA3AF" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" stroke="#9CA3AF" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
                  <div class="placeholder-inner">上传图片</div>
                </template>
              </div>
              <input ref="imageInput" type="file" accept="image/png,image/jpeg" @change="handleImageUpload" hidden />

            </div>
          </div>
        </section>

        <section class="editor-panel" v-else-if="editorTab === 'price'">
          <div class="price-section">
            <div class="form-row">
              <label class="form-field required">
                <div class="field-top">
                  <span class="field-label">售价</span>
                  <span class="required-star">*</span>
                </div>
                <input class="auto-price-input" v-model="editorForm.price" type="number" min="0" step="0.1" placeholder="0.00" readonly title="由原价和折扣自动计算" />
                <div class="auto-price-hint">售价由 原价 和 折扣 自动计算</div>
              </label>
              <label class="form-field">
                <div class="field-top">
                  <span class="field-label">原价</span>
                </div>
                <input v-model="editorForm.originalPrice" type="number" min="0" step="0.1" placeholder="0.00" @wheel.prevent />
              </label>
            </div>
          </div>

          <div class="multi-spec-section">
            <div class="switch-control">
              <div class="switch-info">
                <h4>多规格设置</h4>
                <p>为菜品设置不同规格与对应价格</p>
              </div>
              <label class="switch">
                <input type="checkbox" v-model="editorForm.multiSpec" />
                <span class="slider"></span>
              </label>
            </div>

            <div v-if="editorForm.multiSpec" class="spec-management">
                <div class="add-spec-section">
                  <div class="add-spec-container" >
                    <button class="add-spec-btn" type="button"  @click.prevent="openAddSpecModal">
                      <span class="plus">+</span>
                      <span class="add-spec-label">添加新规格</span>
                    </button>
                  </div>
                </div>

              <div v-if="editorForm.customSpecs && editorForm.customSpecs.length" class="specs-list">
                <h5>已设置的规格</h5>
                <div v-for="spec in editorForm.customSpecs" :key="spec.id" class="spec-card">
                  <label class="form-field">
                    <div class="field-top">
                      <span class="field-label">规格名称</span>
                    </div>
                    <input v-model="spec.name" placeholder="例如：辣度、甜度、份量等" />
                  </label>

                  <div class="spec-options-list">
                    <div v-for="option in spec.options" :key="option.id" class="option-row">
                      <input v-model="option.name" class="option-name" placeholder="选项 1（例如：不辣、微辣）" />
                      <input v-model="option.price" class="option-price" type="number" min="0" step="0.1" placeholder="加价" />
                      <button class="remove-option-btn" @click="removeOption(spec.id, option.id)">×</button>
                    </div>
                    <button class="add-option-block" @click="addSpecOption(spec.id)">+ 添加选项</button>
                  </div>

                  <div class="spec-footer">
                      <button class="btn-neutral" type="button" @click.prevent="cancelSpec(spec.id)">取消</button>
                    <button class="btn-orange" type="button" @click="saveSpec(spec.id)">保存规格</button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="discount-section">
            <div class="switch-control">
              <div class="switch-info">
                <h4>折扣活动</h4>
                <p>设置菜品折扣价格</p>
              </div>
              <label class="switch">
                <input type="checkbox" v-model="editorForm.discount.enable" />
                <span class="slider"></span>
              </label>
            </div>

            <div v-if="editorForm.discount.enable" class="discount-options">
              <div class="discount-methods">
                <label class="radio-option">
                  <input type="radio" v-model="editorForm.discount.method" value="price" />
                  <span>直接设置折扣价</span>
                </label>
                <label class="radio-option">
                  <input type="radio" v-model="editorForm.discount.method" value="percentage" />
                  <span>按折扣比例</span>
                </label>
              </div>

              <div v-if="editorForm.discount.method === 'price'" class="discount-price-input">
                <label class="form-field">
                  <span class="field-label">折扣价</span>
                  <input v-model="editorForm.discount.price" type="number" min="0" step="0.1" placeholder="0.00" @wheel.prevent />
                </label>
              </div>

              <div v-if="editorForm.discount.method === 'percentage'" class="discount-percentage-input">
                <div class="percentage-buttons">
                  <button v-for="rate in [0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6]"
                          :key="rate"
                          class="percentage-btn"
                          @click="setDiscountPercentage(rate)">
                    {{ rate * 10 }}折
                  </button>
                </div>
                <label class="form-field">
                  <span class="field-label">自定义折扣</span>
                  <input v-model="editorForm.discount.percentage" type="number" min="0.1" max="1" step="0.1" placeholder="0.9" />
                </label>
              </div>
            </div>
          </div>
        </section>

        <section v-else-if="editorTab === 'stock'" class="editor-panel">
          <div class="stock-section">
            <div class="form-row">
              <label class="form-field required">
                <div class="field-top">
                  <span class="field-label">库存数量</span>
                  <span class="required-star">*</span>
                </div>
                <input v-model.number="editorForm.stock" type="number" min="0" placeholder="请输入库存数量" />
              </label>
              <label class="form-field required">
                <div class="field-top">
                  <span class="field-label">库存最大容量</span>
                  <span class="required-star">*</span>
                </div>
                <input v-model.number="editorForm.maxCapacity" type="number" min="0" placeholder="请输入库存最大容量" />
              </label>
            </div>
          </div>

          <div class="stock-alert-section">
            <div class="switch-control">
              <div class="switch-info">
                <h4>库存预警</h4>
                <p>库存不足时系统自动提醒</p>
              </div>
              <label class="switch">
                <input type="checkbox" v-model="editorForm.stockAlert.enable" />
                <span class="slider"></span>
              </label>
            </div>

            <div v-if="editorForm.stockAlert.enable" class="stock-alert-settings">
              <label class="form-field">
                <span class="field-label">预警阈值</span>
                <input v-model.number="editorForm.stockAlert.threshold" type="number" min="1" placeholder="低于阈值触发提醒" />
              </label>
            </div>
          </div>
        </section>



        <footer class="editor-actions">
          <button class="btn-neutral" type="button" @click="closeEditor">取消</button>
          <button class="btn-orange" type="button" @click="saveEditor">保存</button>
        </footer>
      </div>
    </div>

    <!-- 新规格弹窗（独立于整体编辑弹窗，支持“规格”快捷按钮直接打开） -->
    <div v-if="showAddSpecModal" class="spec-modal-mask" @click.self="closeAddSpecModal">
      <div class="spec-modal">
        <header class="spec-modal-header">
          <h3>添加新规格</h3>
          <button class="modal-close" type="button" @click="closeAddSpecModal">×</button>
        </header>

        <div class="spec-modal-body">
          <label class="form-field">
            <div class="field-top"><span class="field-label">规格名称</span></div>
            <input v-model="modalSpec.name" placeholder="例如：辣度、甜度、份量等" />
          </label>

          <div class="spec-options-list modal-options">
            <div v-for="opt in modalSpec.options" :key="opt.id" class="option-row-modal">
              <input v-model="opt.name" class="option-name" placeholder="选项名称（例如：不辣、微辣）" />
              <input v-model.number="opt.price" class="option-price" type="number" min="0" step="0.1" placeholder="加价" />
              <button class="remove-option-btn" type="button" @click="removeModalOption(opt.id)">×</button>
            </div>
            <button class="add-option-block" type="button" @click="addModalOption">+ 添加选项</button>
          </div>
        </div>

        <footer class="spec-modal-footer">
          <button class="btn-neutral" type="button" @click="closeAddSpecModal">取消</button>
          <button class="btn-orange" type="button" @click="confirmAddSpecFromModal">保存规格</button>
        </footer>
      </div>
    </div>

    <!-- 下架原因弹窗 -->
    <div v-if="showOffShelfReasonModal" class="off-shelf-mask" @click.self="closeOffShelfReasonModal">
      <div class="off-shelf-modal">
        <header class="off-shelf-header">
          <div class="off-shelf-title">
            <h3>下架菜品</h3>
          </div>
          <button class="off-shelf-close" type="button" @click="closeOffShelfReasonModal">×</button>
        </header>

        <p class="off-shelf-desc">
          确定要下架 <strong>{{ pendingOffShelfDish?.name }}</strong> 吗？请选择或填写下架原因，系统将保留完整的历史记录。
        </p>

        <div class="off-shelf-section">
          <div class="off-shelf-section-title">下架原因</div>
          <label v-for="opt in offShelfReasonOptions" :key="opt" class="off-shelf-radio">
            <input type="radio" name="offShelfReason" :value="opt" v-model="selectedOffShelfReason" />
            <span>{{ opt }}</span>
          </label>
        </div>

        <footer class="off-shelf-actions">
          <button class="btn-neutral" type="button" @click="closeOffShelfReasonModal">取消</button>
          <button class="btn-orange" type="button" @click="confirmOffShelf">确认下架</button>
        </footer>
      </div>
    </div>

    <!-- 下架信息弹窗（展示最近一次） -->
    <div v-if="showOffShelfInfoModal" class="off-shelf-mask" @click.self="closeOffShelfInfoModal">
      <div class="off-shelf-modal off-shelf-info-modal">
        <header class="off-shelf-header">
          <div class="off-shelf-title">
            <span class="off-shelf-icon"></span>
            <h3>下架信息</h3>
          </div>
          <button class="off-shelf-close" type="button" @click="closeOffShelfInfoModal">×</button>
        </header>

        <div class="off-shelf-info-grid">
          <div class="off-shelf-info-card">
            <div class="off-shelf-info-label">菜品名称</div>
            <div class="off-shelf-info-value">{{ pendingInfoDish?.name || '—' }}</div>
          </div>

          <div class="off-shelf-info-card">
            <div class="off-shelf-info-label">下架原因</div>
            <div class="off-shelf-info-value">
              <template v-if="offShelfInfoLoading">加载中...</template>
              <template v-else>{{ offShelfInfo?.reason || '暂无记录' }}</template>
            </div>
          </div>

          <div class="off-shelf-info-card">
            <div class="off-shelf-info-label">下架时间</div>
            <div class="off-shelf-info-value">
              <template v-if="offShelfInfoLoading">加载中...</template>
              <template v-else>{{ formatOffShelfTime(offShelfInfo?.created_at) }}</template>
            </div>
          </div>

          <div class="off-shelf-info-card">
            <div class="off-shelf-info-label">操作人</div>
            <div class="off-shelf-info-value">
              <template v-if="offShelfInfoLoading">加载中...</template>
              <template v-else>{{ offShelfInfo?.operator_name || '当前用户' }}</template>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast Notification -->
    <div v-if="showErrorPopup" class="toast" :class="toastType">
      {{ errorMessage }}
    </div>
  </div>
</template>

<script setup>
import { getMyRestaurant, getMerchantMenu, setDishStatus, getDishOffShelfInfo, batchSetDishStatus, createDish, updateDish, getDish, uploadDishImage } from '@/api/merchant'
import { computed, ref, onMounted, nextTick, watch, onBeforeUnmount } from 'vue'

const keyword = ref('')
const categoryOptions = ref(['全部'])
const statusOptions = ['全部', '上架', '下架']
const activeCategory = ref('全部')
const activeStatus = ref('全部')
const selectedIds = ref([])
const hoverId = ref(null)
const dishes = ref([])
const isLoading = ref(false)
const errorMessage = ref('')
const showErrorPopup = ref(false)
const toastType = ref('success')
const restaurantId = ref(null)
const hasValidRestaurant = ref(false)

// 下架原因 / 下架信息
const showOffShelfReasonModal = ref(false)
const pendingOffShelfDish = ref(null)
const offShelfReasonOptions = [
  '季节性下架',
  '食材缺货',
  '口味调整中',
  '成本过高',
  '销量不佳',
  '配方改良中',
  '其他原因'
]
const selectedOffShelfReason = ref(offShelfReasonOptions[0])

const showOffShelfInfoModal = ref(false)
const pendingInfoDish = ref(null)
const offShelfInfoLoading = ref(false)
const offShelfInfo = ref(null)

// 库存预警相关
const stockAlerts = ref([])
const dismissedAlerts = ref(new Set())

// 从 localStorage 加载已关闭的预警记录（以菜品 id 为 key，关闭后在返回页面时不再弹出）
const loadDismissedAlerts = () => {
  try {
    const stored = localStorage.getItem('dismissedStockAlerts')
    if (stored) {
      // stored 应为数组 of ids
      dismissedAlerts.value = new Set(JSON.parse(stored).map(String))
    }
  } catch (e) {
    console.error('加载预警记录失败:', e)
  }
}

// 保存已关闭的预警记录（以菜品 id 的数组形式存储）
const saveDismissedAlerts = () => {
  try {
    localStorage.setItem('dismissedStockAlerts', JSON.stringify([...dismissedAlerts.value]))
  } catch (e) {
    console.error('保存预警记录失败:', e)
  }
}

// 检查库存预警
const checkStockAlerts = () => {
  const alerts = []
  
  dishes.value.forEach(dish => {
    const stock = dish.stock || {}
    const isLowStock = stock.isLowStock || false
    const alertEnabled = stock.alertEnabled || false
    const threshold = stock.alertThreshold
    const current = stock.current || 0
    
    if (alertEnabled && isLowStock) {
      const alertKey = String(dish.id) // 使用菜品 id 作为 key，关闭后在返回页面时不会再弹出

      // 如果这个菜品的预警未被关闭，则添加到列表
      if (!dismissedAlerts.value.has(alertKey)) {
        alerts.push({
          id: dish.id,
          name: dish.name,
          current: current,
          threshold: threshold,
          alertKey: alertKey
        })
      }
    }
  })
  
  // 限制界面上最多显示 5 条预警，超过则删除最上面的（FIFO：从头部移除）
  if (alerts.length > 5) {
    const excess = alerts.length - 5
    // 从头部移除最早的 excess 条，并将它们标记为已关闭（持久化），避免之后再次弹出
    const removed = alerts.splice(0, excess)
    removed.forEach(a => {
      try {
        dismissedAlerts.value.add(String(a.alertKey))
      } catch (e) {}
    })
    saveDismissedAlerts()
  }

  stockAlerts.value = alerts
}

// 关闭预警（按菜品 id 关闭，关闭后短期内不会再次弹出）
const dismissAlert = (alertKey) => {
  // alertKey 现在就是菜品 id 的字符串
  dismissedAlerts.value.add(String(alertKey))
  saveDismissedAlerts()
  stockAlerts.value = stockAlerts.value.filter(alert => String(alert.alertKey) !== String(alertKey))
}

// 清理无效的预警记录（当库存恢复或预警关闭时）
const cleanupDismissedAlerts = () => {
  // 保留的规则：如果菜品不再处于低库存或未开启预警，则移除其 dismissed 标记
  const stillValid = new Set()

  dishes.value.forEach(dish => {
    const stock = dish.stock || {}
    if (stock.alertEnabled && stock.isLowStock) {
      // 菜品仍然处于预警状态，保留其 id（如果之前关闭过，则继续保留关闭状态）
      // 但我们只需要确保 dismissed 列表中不会包含不存在的菜品 id
      stillValid.add(String(dish.id))
    }
  })

  // 过滤掉那些已经不存在或不再预警的 id
  const updated = new Set([...dismissedAlerts.value].filter(id => stillValid.has(String(id))))

  dismissedAlerts.value = updated
  saveDismissedAlerts()
}

// 关闭当前所有在界面展示的预警（用于路由离开时自动关闭）
const dismissAllCurrentAlerts = () => {
  try {
    stockAlerts.value.forEach(alert => {
      dismissedAlerts.value.add(String(alert.alertKey))
    })
    saveDismissedAlerts()
    stockAlerts.value = []
  } catch (e) {
    console.error('关闭所有预警失败:', e)
  }
}

// 当组件卸载（通常因路由跳转）时，自动关闭当前预警并持久保存关闭状态
onBeforeUnmount(() => {
  dismissAllCurrentAlerts()
})


const initializeRestaurant = async () => {
  try {
    // 直接获取用户的餐厅信息
    const restaurantResponse = await getMyRestaurant()

    const restaurantResult = restaurantResponse.data

    if (!restaurantResult.success || !restaurantResult.data.restaurant_id) {
      showToast('未找到餐厅信息，请先创建餐厅', 'error')
      hasValidRestaurant.value = false
      return
    }

    restaurantId.value = restaurantResult.data.restaurant_id
    hasValidRestaurant.value = true
  } catch (error) {
    showToast('验证餐厅信息失败，请重新登录', 'error')
    hasValidRestaurant.value = false
  }
}

const loadMenu = async () => {

  if (!hasValidRestaurant.value) {
    showToast('未加载到餐厅信息，请刷新页面重试', 'error')
    return
  }

  isLoading.value = true
  try {
    const res = await getMerchantMenu()
    const body = res.data
    if (!body?.success) {
      console.error('菜单加载失败:', body?.message || '菜单加载失败')
      throw new Error(body?.message || '菜单加载失败')
    }
    const payload = body.data || {}

    categoryOptions.value = ['全部', ...(payload.categories || [])]
    dishes.value = (payload.dishes || []).map((item) => {
      const specs = normalizeSpecs(item.specifications)
      const multiSpec = Boolean(item.multi_spec_enabled || specs.length)
      const priceValue = typeof item.price === 'number' ? item.price : parseFloat(item.price) || 0
      const imageSource = item.image || item.image_url || item.imageUrl || ''
      const stockCurrent = item.stock?.current ?? item.stock_quantity ?? 0
      const stockCap = item.stock?.cap ?? item.stock_capacity ?? item.stock_quantity ?? 0
      // 兼容旧状态：sold_out/offline 统一当作 unavailable（下架）处理
      let normalizedStatus =
        item.status === 'sold_out' || item.status === 'offline' ? 'unavailable' : item.status
      // 规则：库存为 0 时自动下架
      if ((stockCurrent || 0) === 0) {
        normalizedStatus = 'unavailable'
      }
      return {
        ...item,
        status: normalizedStatus,
        price: priceValue,
        image: imageSource,
        stock: {
          current: stockCurrent,
          cap: stockCap,
          alertEnabled: item.stock?.alertEnabled ?? item.stock_alert_enabled ?? false,
          alertThreshold: item.stock?.alertThreshold ?? item.stock_alert_threshold ?? null,
          isLowStock: item.stock?.isLowStock ?? false
        },
        tags: item.tags || [],
        multiSpec,
        multi_spec_enabled: multiSpec,
        specifications: specs,
        customSpecs: specs,
        lastUpdated: formatRelativeTime(item.lastUpdated)
      }
    })
    
    // 检查库存预警
    cleanupDismissedAlerts()
    checkStockAlerts()
  } catch (err) {
    console.error('菜单加载错误:', err)
    showToast(err.response?.data?.message || err.message || '菜单加载失败', 'error')
  } finally {
    isLoading.value = false
  }
}

const toggleStatus = async (dish) => {
  // 仅保留两种状态：available(上架) / unavailable(下架)
  const targetStatus = dish.status === 'unavailable' ? 'available' : 'unavailable'

  // 规则：库存为 0 时不允许上架
  if (targetStatus === 'available' && (dish.stock?.current || 0) === 0) {
    showToast('库存为 0，无法上架该菜品', 'error')
    return
  }

  // 下架：必须先填写下架原因
  if (targetStatus === 'unavailable') {
    openOffShelfReasonModal(dish)
    return
  }
  try {
    await setDishStatus(dish.id, targetStatus)
    await loadMenu()
  } catch (err) {
    console.error(err)
    showToast(err.response?.data?.message || err.message || '更新失败', 'error')
  }
}

const openOffShelfReasonModal = (dish) => {
  pendingOffShelfDish.value = dish
  selectedOffShelfReason.value = offShelfReasonOptions[0]
  showOffShelfReasonModal.value = true
}

const closeOffShelfReasonModal = () => {
  showOffShelfReasonModal.value = false
  pendingOffShelfDish.value = null
}

const confirmOffShelf = async () => {
  if (!pendingOffShelfDish.value) return
  const reason = (selectedOffShelfReason.value || '').trim()
  if (!reason) {
    showToast('请选择下架原因', 'error')
    return
  }

  // “食材缺货”视为售罄：后端会强制将原因记为“售罄”
  const status = reason === '食材缺货' ? 'sold_out' : 'unavailable'

  try {
    await setDishStatus(pendingOffShelfDish.value.id, status)
    closeOffShelfReasonModal()
    await loadMenu()
  } catch (err) {
    console.error(err)
    showToast(err.response?.data?.message || err.message || '更新失败', 'error')
  }
}

const openOffShelfInfo = async (dish) => {
  pendingInfoDish.value = dish
  showOffShelfInfoModal.value = true
  offShelfInfo.value = null
  offShelfInfoLoading.value = true
  try {
    const res = await getDishOffShelfInfo(dish.id)
    offShelfInfo.value = res.data.data
  } catch (err) {
    console.error(err)
    showToast(err.response?.data?.message || err.message || '查询失败', 'error')
  } finally {
    offShelfInfoLoading.value = false
  }
}

const closeOffShelfInfoModal = () => {
  showOffShelfInfoModal.value = false
  pendingInfoDish.value = null
  offShelfInfo.value = null
}

const formatOffShelfTime = (isoString) => {
  if (!isoString) return '—'
  const date = new Date(isoString)
  if (Number.isNaN(date.getTime())) return '—'
  const y = date.getFullYear()
  const m = date.getMonth() + 1
  const d = date.getDate()
  const hh = String(date.getHours()).padStart(2, '0')
  const mm = String(date.getMinutes()).padStart(2, '0')
  return `${y}年${m}月${d}日 ${hh}:${mm}`
}

const batchToggleStatus = async (status) => {
  if (!selectedIds.value.length) return

  // 规则：批量上架时，跳过库存为 0 的菜品
  let dishIds = selectedIds.value
  if (status === 'available') {
    const selectedSet = new Set(selectedIds.value)
    const allowed = dishes.value
      .filter(d => selectedSet.has(d.id) && (d.stock?.current || 0) > 0)
      .map(d => d.id)
    const skipped = selectedIds.value.length - allowed.length
    dishIds = allowed
    if (!dishIds.length) {
      showToast('所选菜品库存均为 0，无法批量上架', 'error')
      return
    }
    if (skipped > 0) {
      showToast(`已跳过 ${skipped} 个库存为 0 的菜品`, 'error')
    }
  }
  try {
    await batchSetDishStatus({ dish_ids: dishIds, status })
    selectedIds.value = []
    await loadMenu()
  } catch (err) {
    console.error(err)
    showToast(err.response?.data?.message || err.message || '批量更新失败', 'error')
  }
}

// const batchTag = async () => {
//   if (!selectedIds.value.length) return
//   try {
//     await fetch('/api/dishes/batch-tags', {
//       method: 'POST',
//       headers: buildAuthHeaders(),
//       body: JSON.stringify({ dish_ids: selectedIds.value, tag: '促销' })
//     }).then(async (res) => {
//       const body = await res.json()
//       if (!res.ok || !body.success) {
//         throw new Error(body.message || '标签更新失败')
//       }
//     })
//     selectedIds.value = []
//     await loadMenu()
//   } catch (err) {
//     console.error(err)
//     showToast(err.message || '标签更新失败', 'error')
//   }
// }

const saveEditor = async () => {
  try {
    if (!hasValidRestaurant.value || !restaurantId.value) {
      errorMessage.value = '未找到餐厅信息，请先创建餐厅'
      return
    }

    const validationErrors = []

    // 准备发送给后端的数据
    const saveData = {
      restaurant_id: restaurantId.value,
      name: editorForm.value.name?.trim() || '',
      category: editorForm.value.category?.trim() || '',
      description: editorForm.value.description?.trim() || '',
      price: parseFloat(editorForm.value.price) || 0,
      original_price: editorForm.value.originalPrice ? parseFloat(editorForm.value.originalPrice) : null,
      status: editorForm.value.status || 'available',
      tags: [],
      monthly_sales: 0,
    }
    const specsPayload = buildSpecsPayload(editorForm.value)
    saveData.multi_spec_enabled = specsPayload.enabled
    saveData.specifications = specsPayload.items

    if (editorForm.value.multiSpec && !specsPayload.enabled) {
      validationErrors.push('请完善至少一个规格及其选项')
    }
    // 后端允许为空但需要格式化的字段
    if (editorForm.value.image?.trim()) {
      // 如果是本地预览的图片（blob URL），需要先上传
      if (editorForm.value.image.startsWith('blob:')) {
        showToast('请先完成图片上传', 'error')
        return
      }
      saveData.image_url = editorForm.value.image.trim()
    }
    // 注意：stock 可能为 0（v-model.number），不能用 truthy 判断
    if (editorForm.value.stock !== undefined && editorForm.value.stock !== null && editorForm.value.stock !== '') {
      const stockValue = parseInt(editorForm.value.stock)
      if (!isNaN(stockValue)) {
        saveData.stock_quantity = stockValue
      }
    }

    // 规则：库存为 0 时强制下架
    if ((saveData.stock_quantity || 0) === 0) {
      saveData.status = 'unavailable'
    }
    // 使用 editorForm.maxCapacity 作为库存上限（优先），若未填写则回退到当前库存数量
    const parsedMaxCapacity = parseInt(editorForm.value.maxCapacity)
    if (!isNaN(parsedMaxCapacity)) {
      saveData.stock_capacity = parsedMaxCapacity
    } else if (saveData.stock_quantity !== undefined) {
      saveData.stock_capacity = saveData.stock_quantity
    }
    // 库存预警设置
    saveData.stock_alert_enabled = Boolean(editorForm.value.stockAlert?.enable)
    if (saveData.stock_alert_enabled && editorForm.value.stockAlert?.threshold !== undefined) {
      const thresholdValue = parseInt(editorForm.value.stockAlert.threshold)
      if (!isNaN(thresholdValue) && thresholdValue >= 0) {
        saveData.stock_alert_threshold = thresholdValue
      }
    }

    // 折扣设置
    saveData.discount_enabled = Boolean(editorForm.value.discount?.enable)
    if (saveData.discount_enabled) {
      saveData.discount_method = editorForm.value.discount.method
      if (saveData.discount_method === 'price') {
        saveData.discount_price = parseFloat(editorForm.value.discount.price)
        saveData.discount_percentage = null
      } else if (saveData.discount_method === 'percentage') {
        saveData.discount_percentage = parseFloat(editorForm.value.discount.percentage)
        saveData.discount_price = null
      }
    } else {
      saveData.discount_price = null
      saveData.discount_percentage = null
    }

    // 如果是编辑模式，添加菜品ID
    if (editorForm.value.id) {
      saveData.dish_id = parseInt(editorForm.value.id)
    }
    // 验证必填字段 - 与后端保持一致
    // 验证菜品名称
    if (!saveData.name || saveData.name.trim().length === 0) {
      validationErrors.push('菜品名称不能为空')
    } else if (saveData.name.length > 100) {
      validationErrors.push('菜品名称长度不能超过100个字符')
    }
    // 验证价格
    if (isNaN(saveData.price) || saveData.price < 0) {
      validationErrors.push('价格必须是有效的非负数')
    } else if (saveData.price > 999999.99) {
      validationErrors.push('价格不能超过999999.99')
    }

    // 验证原价
    if (saveData.original_price !== null) {
      if (isNaN(saveData.original_price) || saveData.original_price < 0) {
        validationErrors.push('原价必须是有效的非负数')
      } else if (saveData.original_price > 999999.99) {
        validationErrors.push('原价不能超过999999.99')
      }
    }

    // 验证分类（后端允许为空）
    if (saveData.category && saveData.category.length > 50) {
      validationErrors.push('分类长度不能超过50个字符')
    }
    // 验证状态（仅保留 available/unavailable；兼容旧值 sold_out/offline 统一按 unavailable 处理）
    if (saveData.status === 'sold_out' || saveData.status === 'offline') {
      saveData.status = 'unavailable'
    }
    const validStatuses = ['available', 'unavailable']
    if (!validStatuses.includes(saveData.status)) {
      validationErrors.push('状态必须是以下之一: available, unavailable')
    }
    // 验证图片URL（后端允许为空）
    if (saveData.image_url && saveData.image_url.length > 255) {
      validationErrors.push('图片URL长度不能超过255个字符')
    }
    // 验证库存数量（后端允许为空）
    if (saveData.stock_quantity !== undefined && saveData.stock_quantity < 0) {
      validationErrors.push('库存不能为负数')
    }
    
    // 验证最大库存量（必填项）
    if (!saveData.stock_capacity && saveData.stock_capacity !== 0) {
      validationErrors.push('最大库存量为必填项')
    } else if (saveData.stock_capacity < 0) {
      validationErrors.push('最大库存量不能为负数')
    }
    
    // 验证库存量不得超过最大库存量
    if (saveData.stock_quantity !== undefined && saveData.stock_capacity !== undefined) {
      if (saveData.stock_quantity > saveData.stock_capacity) {
        validationErrors.push('库存数量不得超过最大库存量')
      }
    }
    // 验证库存预警设置
    if (saveData.stock_alert_enabled) {
      if (!saveData.stock_alert_threshold && saveData.stock_alert_threshold !== 0) {
        validationErrors.push('启用库存预警时必须设置预警阈值')
      } else if (saveData.stock_alert_threshold < 0) {
        validationErrors.push('预警阈值不能为负数')
      } else if (saveData.stock_quantity && saveData.stock_alert_threshold > saveData.stock_quantity) {
        validationErrors.push('预警阈值不应大于当前库存')
      }
    }

    // 验证折扣设置
    if (saveData.discount_enabled) {
      if (saveData.discount_method === 'price') {
        if (saveData.discount_price === undefined || isNaN(saveData.discount_price)) {
          validationErrors.push('启用定额折扣时必须设置有效的折扣价格')
        } else if (saveData.discount_price < 0) {
          validationErrors.push('折扣价格不能为负数')
        }
      } else if (saveData.discount_method === 'percentage') {
        if (saveData.discount_percentage === undefined || isNaN(saveData.discount_percentage)) {
          validationErrors.push('启用比例折扣时必须设置有效的折扣百分比')
        } else if (saveData.discount_percentage < 0 || saveData.discount_percentage > 1) {
          validationErrors.push('折扣百分比必须在0到1之间')
        }
      }
    }

    if (validationErrors.length > 0) {
      showToast('数据验证失败: ' + validationErrors.join(', '), 'error')
      return
    }
    // 调用API保存菜品
    let response;
    if (saveData.dish_id) {
      response = await updateDish(saveData.dish_id, saveData)
    } else {
      response = await createDish(saveData)
    }
    const result = response.data
    if (!result.success) {
      throw new Error(result.message || '保存失败')
    }
    // 关闭编辑器并刷新菜单
    closeEditor()
    await loadMenu()
    // 显示成功消息
    showToast(result.message || '保存成功', 'success')
  } catch (error) {
    console.error('保存菜品失败:', error)
    showToast(error.response?.data?.message || error.message || '保存失败，请重试', 'error')
  }
}

const processUploadFile = async (file) => {
  // 验证文件大小
  if (file.size > 5 * 1024 * 1024) {
    showToast('图片大小不可超过 5MB', 'error')
    return
  }

  // 验证文件类型
  const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg']
  if (!allowedTypes.includes(file.type)) {
    showToast('只支持 PNG、JPG 格式的图片', 'error')
    return
  }

  try {
    // 先生成本地预览，提升体验
    const previewUrl = URL.createObjectURL(file)
    editorForm.value.image = previewUrl
    // 显示加载状态
    showToast('正在上传图片...', 'success')

    // 创建 FormData 对象
    const formData = new FormData()
    formData.append('file', file)

    // 调用上传 API
    const response = await uploadDishImage(formData)

    const result = response.data

    if (!result.success) {
      // 上传失败，撤销本地预览
      try { URL.revokeObjectURL(previewUrl) } catch (e) {}
      editorForm.value.image = ''
      throw new Error(result.message || '图片上传失败')
    }

    // 成功：使用后端返回的地址替换预览
    const returned = result.url || result.data?.url || ''
    // 如果后端返回的是相对路径，getImageUrl 会处理展示
    editorForm.value.image = returned || previewUrl
    // 撤销本地 blob（当已用后端 URL 时）
    if (returned && previewUrl && previewUrl.startsWith('blob:')) {
      try { URL.revokeObjectURL(previewUrl) } catch (e) {}
    }
    showToast('图片上传成功', 'success')

  } catch (error) {
    console.error('图片上传失败:', error)
    showToast(error.response?.data?.message || error.message || '图片上传失败，请重试', 'error')
  }
}

const handleImageUpload = async (event) => {
  const file = event.target.files?.[0]
  if (!file) return
  await processUploadFile(file)
  // 清空文件输入，允许重复选择同一文件
  event.target.value = ''
}

const isDragging = ref(false)

const handleDrop = async (event) => {
  isDragging.value = false
  const file = event.dataTransfer.files?.[0]
  if (!file) return
  await processUploadFile(file)
}

onMounted(async () => {
  loadDismissedAlerts()
  await initializeRestaurant()
  await loadMenu()
})

const normalizedKeyword = computed(() => keyword.value.trim().toLowerCase())

const filteredDishes = computed(() =>
  dishes.value.filter((dish) => {
    const matchKeyword =
      !normalizedKeyword.value ||
      dish.name?.toLowerCase().includes(normalizedKeyword.value) ||
      dish.category?.toLowerCase().includes(normalizedKeyword.value)
    const matchCategory = activeCategory.value === '全部' || dish.category === activeCategory.value
    const matchStatus =
      activeStatus.value === '全部' ||
      (activeStatus.value === '上架' && dish.status === 'available') ||
      (activeStatus.value === '下架' && dish.status === 'unavailable')
    return matchKeyword && matchCategory && matchStatus
  })
)

const getImageUrl = (imageUrl) => {
  if (!imageUrl) {
    return 'https://via.placeholder.com/300x200?text=No+Image'
  }
  if (imageUrl.startsWith('blob:')) {
    return imageUrl
  }
  if (/^https?:\/\//i.test(imageUrl)) {
    return imageUrl
  }
  const normalizedPath = imageUrl.startsWith('/') ? imageUrl : `/${imageUrl}`
  return `${API_url}${normalizedPath.replace(/\/\/+/g, '/')}`
}

const stockRatio = (dish) => {
  const cap = dish.stock?.cap || 0
  if (!cap) return 0
  return (dish.stock?.current || 0) / cap
}

const toggleSelect = (dishId) => {
  const id = Number(dishId)
  selectedIds.value = selectedIds.value.includes(id)
    ? selectedIds.value.filter((existing) => existing !== id)
    : [...selectedIds.value, id]
}
const normalizeSpecs = (rawSpecs = []) =>
  (Array.isArray(rawSpecs) ? rawSpecs : []).map((spec, specIndex) => ({
    id: spec.id || `spec-${specIndex}`,
    name: spec.name || '',
    options: (spec.options || []).map((opt, optIndex) => ({
      id: opt.id || `spec-${specIndex}-opt-${optIndex}`,
      name: opt.name || '',
      price: typeof opt.price === 'number' ? opt.price : parseFloat(opt.price) || 0
    }))
  }))

const buildSpecsPayload = (form) => {
  if (!form.multiSpec) return { enabled: false, items: [] }
  const items = (form.customSpecs || [])
    .map((spec) => ({
      name: spec.name?.trim() || '',
      options: (spec.options || [])
        .map((opt) => ({
          name: opt.name?.trim() || '',
          price: typeof opt.price === 'number' ? opt.price : parseFloat(opt.price) || 0
        }))
        .filter((opt) => opt.name)
    }))
    .filter((spec) => spec.name && spec.options.length)
  return { enabled: items.length > 0, items }
}
const openAddDish = () => {
  const defaultCategory = activeCategory.value !== '全部' ? activeCategory.value : ''
  showEditor.value = true
  editorTab.value = 'basic'
  editorForm.value = createEmptyEditorForm(defaultCategory)
}

const showEditor = ref(false)
const editorTab = ref('basic')
const editorTabs = [
  { value: 'basic', label: '基本信息' },
  { value: 'price', label: '价格' },
  { value: 'stock', label: '库存' }
]
const editorForm = ref(createEmptyEditorForm())
const imageInput = ref(null)
const newSpecName = ref('')
const showAddSpecModal = ref(false)
const modalSpec = ref({ id: '', name: '', options: [] })
const specQuickMode = ref(false)
const specQuickDishDetail = ref(null)
const isAddingCategory = ref(false)
const newCategoryName = ref('')
const newCategoryInput = ref(null)
const lastSelectedCategory = ref('')

const resetSpecQuickContext = () => {
  specQuickMode.value = false
  specQuickDishDetail.value = null
}

const categorySelectOptions = computed(() =>
  categoryOptions.value.filter((opt) => opt && opt !== '全部')
)

const renderedCategorySelectOptions = computed(() =>
  categorySelectOptions.value.length
    ? categorySelectOptions.value.map((option) => ({
        label: option,
        value: option,
        disabled: false
      }))
    : [{ label: '无', value: '__empty__', disabled: true }]
)

const handleCategoryChange = (value) => {
  if (value === '__new__') {
    editorForm.value.category = lastSelectedCategory.value || ''
    startAddCategory()
    return
  }
  if (value) {
    lastSelectedCategory.value = value
  }
}

const startAddCategory = () => {
  if (isAddingCategory.value) return
  isAddingCategory.value = true
  newCategoryName.value = ''
  nextTick(() => newCategoryInput.value?.focus())
}

const confirmNewCategory = () => {
  const name = newCategoryName.value.trim()
  if (!name) return
  if (!categorySelectOptions.value.includes(name)) {
    categoryOptions.value = ['全部', ...categorySelectOptions.value, name]
  }
  editorForm.value.category = name
  lastSelectedCategory.value = name
  isAddingCategory.value = false
  newCategoryName.value = ''
}

const cancelNewCategory = () => {
  isAddingCategory.value = false
  newCategoryName.value = ''
  editorForm.value.category = lastSelectedCategory.value || categorySelectOptions.value[0] || ''
}

function createEmptyEditorForm(initialCategory = '') {
  const fallbackCategory =
    initialCategory ||
    categoryOptions.value.find((opt) => opt !== '全部') ||
    ''
  if (fallbackCategory) {
    lastSelectedCategory.value = fallbackCategory
  }
  return {
    id: '',
    name: '',
    category: fallbackCategory,
    description: '',
    image: '',
    price: '',
    originalPrice: '',
    multiSpec: false,
    customSpecs: [],
    discount: {
      enable: false,
      method: 'price',
      price: '',
      percentage: 1.0
    },
    stock: 0,
    maxCapacity: 0,
    stockAlert: { enable: false, threshold: 10 },
    status: 'available'
  }
}

const openSpecs = async (dish) => {
  if (!dish) return

  // 规格快捷按钮：不打开整体编辑弹窗，直接弹出“新增规格”弹窗
  showEditor.value = false
  specQuickMode.value = true

  try {
    // 先拉取菜品详情，避免 PUT 时把 is_spicy_selectable / discount / 预警等字段重置为默认值
    const params = restaurantId.value ? { restaurant_id: restaurantId.value } : {}
    const res = await getDish(dish.id, params)
    const body = res.data
    if (!body?.success) {
      throw new Error(body?.message || '获取菜品详情失败')
    }
    specQuickDishDetail.value = body.data

    // 仅用于规格编辑承载；不会打开整体弹窗
    editorTab.value = 'price'
    editorForm.value = {
      ...createEmptyEditorForm(body.data?.category || ''),
      id: body.data?.dish_id ?? dish.id,
      name: body.data?.name ?? dish.name,
      category: body.data?.category ?? dish.category,
      description: body.data?.description ?? dish.description ?? '',
      price: body.data?.price ?? dish.price,
      originalPrice: body.data?.original_price ?? dish.originalPrice ?? null,
      stock: body.data?.stock_quantity ?? dish.stock?.current ?? 0,
      maxCapacity: body.data?.stock_capacity ?? dish.stock?.cap ?? 0,
      stockAlert: {
        enable: body.data?.stock_alert_enabled ?? dish.stock?.alertEnabled ?? false,
        threshold: body.data?.stock_alert_threshold ?? dish.stock?.alertThreshold ?? 10
      },
      discount: {
        enable: body.data?.discount_enabled ?? dish.discount?.enable ?? false,
        method: body.data?.discount_method ?? dish.discount?.method ?? 'price',
        price: body.data?.discount_price ?? dish.discount?.price ?? '',
        percentage: body.data?.discount_percentage ?? dish.discount?.percentage ?? 1.0
      },
      image: (body.data?.image_url ?? (dish.image || dish.image_url || dish.imageUrl || '')),
      status: body.data?.status ?? dish.status ?? 'available',
      multiSpec: true,
      customSpecs: normalizeSpecs(body.data?.specifications || dish.specifications || [])
    }

    openAddSpecModal()
    await nextTick()
  } catch (err) {
    console.error(err)
    resetSpecQuickContext()
    showToast(err.message || '打开规格失败', 'error')
  }
}

const editDish = (dish) => {
  showEditor.value = true
  editorTab.value = 'basic'
  editorForm.value = {
    ...createEmptyEditorForm(),
    id: dish.id,
    name: dish.name,
    category: dish.category,
    description: dish.description ?? '',
    price: dish.price,
    originalPrice: dish.originalPrice ?? '',
    stock: dish.stock?.current ?? 0,
    maxCapacity: dish.stock?.cap ?? 0,
    stockAlert: {
      enable: dish.stock?.alertEnabled ?? false,
      threshold: dish.stock?.alertThreshold ?? 10
    },
    discount: {
      enable: dish.discount?.enable ?? false,
      method: dish.discount?.method ?? 'price',
      price: dish.discount?.price ?? '',
      percentage: dish.discount?.percentage ?? 1.0
    },
    image: dish.image || dish.image_url || dish.imageUrl || '',
    status: dish.status ?? 'available',
    multiSpec: Boolean(dish.multi_spec_enabled || dish.multiSpec || (dish.customSpecs?.length)),
    customSpecs: JSON.parse(JSON.stringify(dish.customSpecs || dish.specifications || []))
  }
  lastSelectedCategory.value = dish.category || ''
}

watch(
  () => editorForm.value.category,
  (val) => {
    if (!isAddingCategory.value && val) {
      lastSelectedCategory.value = val
    }
  }
)

const closeEditor = () => {
  showEditor.value = false
  showAddSpecModal.value = false
  resetSpecQuickContext()
  editorForm.value = createEmptyEditorForm()
}

const showToast = (message, type = 'success') => {
  errorMessage.value = message
  toastType.value = type
  showErrorPopup.value = true
  setTimeout(() => {
    showErrorPopup.value = false
    errorMessage.value = ''
  }, 600)
}



const openAddSpecModal = () => {
  // 默认是编辑弹窗内部使用（不自动保存）
  if (showEditor.value) {
    resetSpecQuickContext()
  }
  showAddSpecModal.value = true
  modalSpec.value = {
    id: `custom-spec-${Date.now()}`,
    name: '',
    options: [{ id: `option-${Date.now()}`, name: '', price: 0 }]
  }
}

const closeAddSpecModal = () => {
  showAddSpecModal.value = false

  // 如果是快捷入口打开的弹窗，取消时清理临时上下文，避免影响后续编辑
  if (specQuickMode.value && !showEditor.value) {
    editorForm.value = createEmptyEditorForm()
    resetSpecQuickContext()
  }
}

const addModalOption = () => {
  modalSpec.value.options.push({ id: `option-${Date.now()}`, name: '', price: 0 })
}

const removeModalOption = (optId) => {
  modalSpec.value.options = modalSpec.value.options.filter(o => o.id !== optId)
}

const confirmAddSpecFromModal = async () => {
  const spec = modalSpec.value
  if (!spec.name || !spec.name.trim()) {
    showToast('规格名称不能为空', 'error')
    return
  }
  // ensure options have names
  for (const o of spec.options) {
    if (!o.name || !o.name.trim()) {
      showToast('选项名称不能为空', 'error')
      return
    }
    if (o.price === undefined || o.price === null || isNaN(Number(o.price))) {
      o.price = 0
    }
  }
  if (!Array.isArray(editorForm.value.customSpecs)) {
    editorForm.value.customSpecs = []
  }
  editorForm.value.customSpecs.push(JSON.parse(JSON.stringify(spec)))
  editorForm.value.multiSpec = true

  // 快捷入口：保存规格到后端并刷新；编辑弹窗：仅更新本地，等用户点“保存”
  if (specQuickMode.value) {
    try {
      const detail = specQuickDishDetail.value
      if (!detail) {
        throw new Error('菜品详情缺失，无法保存')
      }

      const specsPayload = buildSpecsPayload(editorForm.value)

      const payload = {
        restaurant_id: detail.restaurant_id,
        name: detail.name,
        description: detail.description || '',
        price: detail.price,
        original_price: detail.original_price,
        category: detail.category || '',
        status: detail.status,
        image_url: detail.image_url,
        stock_quantity: detail.stock_quantity,
        stock_capacity: detail.stock_capacity,
        stock_alert_enabled: detail.stock_alert_enabled,
        stock_alert_threshold: detail.stock_alert_threshold,
        discount_enabled: detail.discount_enabled,
        discount_method: detail.discount_method,
        discount_price: detail.discount_price,
        discount_percentage: detail.discount_percentage,
        is_spicy_selectable: detail.is_spicy_selectable,
        is_garnish_selectable: detail.is_garnish_selectable,
        multi_spec_enabled: specsPayload.enabled,
        specifications: specsPayload.items
      }

      const resp = await updateDish(detail.dish_id, payload)
      const respBody = resp.data
      if (!respBody?.success) {
        throw new Error(respBody?.message || '保存规格失败')
      }

      showAddSpecModal.value = false
      showToast(respBody?.message || '保存成功', 'success')
      await loadMenu()
    } catch (e) {
      console.error(e)
      showToast(e.response?.data?.message || e.message || '保存规格失败', 'error')
      return
    } finally {
      editorForm.value = createEmptyEditorForm()
      resetSpecQuickContext()
    }
  } else {
    showToast('已添加规格', 'success')
    showAddSpecModal.value = false
  }
}

const addSpecOption = (specId) => {
  const spec = editorForm.value.customSpecs.find(s => s.id === specId)
  if (spec) {
    spec.options.push({
      id: `option-${Date.now()}`,
      name: '',
      price: 0
    })
  }
}
const removeOption = (specId, optionId) => {
  const spec = editorForm.value.customSpecs.find(s => s.id === specId)
  if (spec) {
    spec.options = spec.options.filter(option => option.id !== optionId)
  }
}

const saveSpec = (specId) => {
  const spec = editorForm.value.customSpecs.find(s => s.id === specId)
  if (!spec) return
  if (!spec.name || !spec.name.trim()) {
    showToast('规格名称不能为空', 'error')
    return
  }
  // 简单校验：每个选项需有名称
  for (const opt of spec.options) {
    if (!opt.name || !opt.name.trim()) {
      showToast('选项名称不能为空', 'error')
      return
    }
    if (opt.price === undefined || opt.price === null || isNaN(Number(opt.price))) {
      opt.price = 0
    }
  }
  editorForm.value.multiSpec = true
  showToast('已保存规格', 'success')
}

const cancelSpec = (specId) => {
  if (!Array.isArray(editorForm.value.customSpecs)) {
    editorForm.value.customSpecs = []
    editorForm.value.multiSpec = false
    return
  }

  const before = editorForm.value.customSpecs.length
  editorForm.value.customSpecs = editorForm.value.customSpecs.filter(
    (spec) => String(spec.id) !== String(specId)
  )

  if (before === editorForm.value.customSpecs.length) {
    return
  }

  if (!editorForm.value.customSpecs.length) {
    editorForm.value.multiSpec = false
  }

  showToast('已移除该规格（保存后生效）', 'success')
}

// 折扣设置方法
const setDiscountPercentage = (rate) => {
  editorForm.value.discount.percentage = rate
}

// 自动计算售价：根据 originalPrice 与 折扣设置计算并写入 editorForm.price
const computePrice = () => {
  const form = editorForm.value || {}
  const orig = Number(form.originalPrice) || 0
  const disc = form.discount || {}
  let p = orig

  if (disc.enable) {
    if (disc.method === 'price') {
      const dp = Number(disc.price)
      if (!Number.isNaN(dp)) p = dp
    } else if (disc.method === 'percentage') {
      const pct = Number(disc.percentage)
      if (!Number.isNaN(pct)) p = +(orig * pct)
    }
  }

  // 保留两位小数
  form.price = Math.round((Number(p) + Number.EPSILON) * 100) / 100
}

// 监听原价与折扣字段变化，实时更新价格
watch(
  () => [editorForm.value.originalPrice, editorForm.value.discount?.enable, editorForm.value.discount?.method, editorForm.value.discount?.price, editorForm.value.discount?.percentage],
  computePrice,
  { immediate: true }
)

const triggerImageUpload = () => imageInput.value?.click()

const removeImage = () => {
  try {
    const current = editorForm.value.image
    if (!current) return
    // 如果是 blob URL，撤销以释放内存
    if (typeof current === 'string' && current.startsWith('blob:')) {
      try { URL.revokeObjectURL(current) } catch (e) { /* ignore */ }
    }
    editorForm.value.image = ''
    showToast('已移除图片', 'success')
  } catch (err) {
    console.error('移除图片失败', err)
    showToast('移除图片失败', 'error')
  }
}

const formatRelativeTime = (isoString) => {
  if (!isoString) return ''
  const target = new Date(isoString)
  if (Number.isNaN(target.getTime())) return ''
  const diffSeconds = Math.round((Date.now() - target.getTime()) / 1000)
  if (diffSeconds < 60) return `${Math.max(diffSeconds, 1)} 秒前`
  const diffMinutes = Math.round(diffSeconds / 60)
  if (diffMinutes < 60) return `${diffMinutes} 分钟前`
  const diffHours = Math.round(diffMinutes / 60)
  if (diffHours < 24) return `${diffHours} 小时前`
  const diffDays = Math.round(diffHours / 24)
  return `${diffDays} 天前`
}
</script>

<style scoped>
.menu-page {
  min-height: 100vh;
  background: #fff7ed;
  display: flex;
  flex-direction: column;
}

.menu-content {
  background-color: #fff7ed;
}

.filters-panel {
  background: #fff;
  margin: 0 32px;
  padding: 24px 28px;
  border-radius: 16px;
  box-shadow: 0 8px 20px rgba(31, 41, 55, 0.08);
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.filters-row {
  display: flex;
  align-items: center;
  gap: 18px;
  flex-wrap: wrap;
}

.search-box {
  display: flex;
  align-items: center;
  background: #f1f5f9;
  border-radius: 999px;
  padding: 10px 18px;
  gap: 12px;
  flex: 1 1 420px;
  transition: box-shadow 0.2s;
}

.search-box:focus-within {
  box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.2);
  background: #fff;
}

.search-box input {
  flex: 1;
  border: none;
  outline: none;
  background: transparent;
  font-size: 15px;
  color: #111827;
}

.filters-actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.chips-group {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.chip-label {
  color: #6b7280;
  font-size: 14px;
  font-weight: 500;
}

.chip {
  border: none;
  background: #f8fafc;



  color: #475569;
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}

.chip.active {
  background: rgba(14, 165, 233, 0.12);
  color: #0284c7;
  box-shadow: inset 0 0 0 1px rgba(2, 132, 199, 0.6);
}

.dishes-section {
  padding: 24px 32px 48px;
  background: #fff7ed;
  flex: 1;
}

.dishes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(310px, 310px));
  justify-content: center;
  gap: 24px;
}

.dish-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  height: 420px; /* 固定卡片总高度 */
  min-height: 420px;
  width: 320px;
  min-width: 320px;
}

.dish-card:hover {
  transform: translateY(-4px) scale(1.01);
  box-shadow: 0 16px 32px rgba(2, 132, 199, 0.18);
}

.dish-card.selected {
  box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.5), 0 14px 30px rgba(14, 165, 233, 0.2);
}

.card-media {
.spec-modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(15,23,42,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1400;
}
.spec-modal {
  width: min(520px, 92vw);
  background: white;
  border-radius: 12px;
  padding: 18px;
  box-shadow: 0 20px 50px rgba(2,6,23,0.3);
}
.spec-modal-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:12px }
.spec-modal-header h3 { margin:0; font-size:16px }
.modal-close { border:none; background:rgba(15,23,42,0.06); width:32px; height:32px; border-radius:8px; cursor:pointer }
.spec-modal-body { display:flex; flex-direction:column; gap:12px }
.option-row-modal { display:grid; grid-template-columns: 1fr 100px 32px; gap:8px; align-items:center }
.option-name, .option-price { padding:8px 10px; border-radius:8px; border:1px solid #e6e9ef; background:#f8fafc }
.spec-modal-footer { display:flex; gap:12px; justify-content:flex-end; margin-top:12px }
  position: relative;
  height: 200px;
  overflow: hidden;
  flex-shrink: 0;
}

.card-media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.dish-card:hover .card-media img {
  transform: scale(1.06);
}

.media-overlay {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  gap: 6px;
}

.badge {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 999px;
  color: #fff;
  font-weight: 500;
}

.badge-hot {
  background: linear-gradient(90deg, #f97316, #fb923c);
}

.badge-new {
  background: linear-gradient(90deg, #0ea5e9, #38bdf8);
}

.select-toggle {
  position: absolute;
  top: 12px;
  right: 12px;
  border: none;
  background: rgba(255, 255, 255, 0.92);
  border-radius: 8px;
  padding: 6px 12px;
  cursor: pointer;
  font-weight: 600;
  color: #0f172a;
}

.card-body {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 18px 20px 12px;
}

.title-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 10px;
}

.title-row h3 {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.category-pill {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(148, 163, 184, 0.16);
  color: #475569;
}

.price-row .price {
  font-size: 18px;
  font-weight: 600;
  color: #ef4444;
  letter-spacing: 0.02em;
}

.meta-row {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: #6b7280;
}

.meta-row .stock.warning {
  color: #f97316;
  font-weight: 600;
}

.status-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.status-chip {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 999px;
  font-weight: 500;
}

.status-chip.success {
  background: rgba(34, 197, 94, 0.16);
  color: #16a34a;
}

.status-chip.muted {
  background: rgba(148, 163, 184, 0.2);
  color: #475569;
}

.status-chip.outline {
  background: rgba(148, 163, 184, 0.1);
  color: #64748b;
}

.card-actions {
  display: flex;
  gap: 14px;
  padding: 10px 20px 20px;
  border-top: 1px solid rgba(226, 232, 240, 0.8);
  align-items: stretch;
}

.card-actions button {
  flex: 1;
  min-width: 0;
  text-align: center;
}

.primary-btn,
.ghost-btn,
.danger-btn,
.warning-btn {
  border: none;
  border-radius: 10px;
  font-size: 13px;
  padding: 10px 14px;
  cursor: pointer;
  font-weight: 600;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.primary-btn {
  background: linear-gradient(90deg, #0ea5e9, #38bdf8);
  color: #fff;
  box-shadow: 0 6px 14px rgba(14, 165, 233, 0.3);
}

.primary-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 20px rgba(14, 165, 233, 0.4);
}

.danger-btn {
  background: linear-gradient(90deg, #ef4444, #f87171);
  color: #fff;
  box-shadow: 0 6px 14px rgba(239, 68, 68, 0.3);
}

.danger-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 20px rgba(239, 68, 68, 0.4);
}

.warning-btn {
  background: linear-gradient(90deg, #f59e0b, #fbbf24);
  color: #fff;
  box-shadow: 0 6px 14px rgba(245, 158, 11, 0.28);
}

.warning-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 20px rgba(245, 158, 11, 0.38);
}

.ghost-btn {
  background: rgba(15, 23, 42, 0.05);
  color: #1f2937;
}

.ghost-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.icon-search {
  width: 16px;
  height: 16px;
}

.ghost-btn:hover:not(:disabled),
.select-toggle:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(15, 23, 42, 0.12);
}

.empty-state {
  margin: 80px auto;
  max-width: 360px;
  text-align: center;
  color: #475569;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.empty-state img {
  width: 200px;
  margin: 0 auto;
}

.dish-editor-mask {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1200;
}

.editor-shell {
  width: min(900px, 40vw);
  max-height: 80vh;
  background: #ffffff;
  border-radius: 18px;
  display: flex;
  flex-direction: column;
  box-shadow: 0 28px 60px rgba(15, 23, 42, 0.22);
  overflow: hidden;
}

.editor-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 24px 28px 12px;
  border-bottom: none; /* 移除旧分隔线 */
}

.editor-separator {
  height: 1px;
  background: linear-gradient(to right, #e5e7eb, #dbe0e6, #e5e7eb);
  margin: 0 5px 12px;
  border-radius: 2px;
}

/* 若需更轻的分隔可切换为:
.editor-separator { background:#e5e7eb; }
*/

.editor-title h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
  color: #111827;
}

.editor-title p {
  margin: 8px 0 0;
  font-size: 13px;
  color: #64748b;
}

.editor-close {
  border: none;
  background: rgba(15, 23, 42, 0.06);
  color: #475569;
  width: 32px;
  height: 32px;
  border-radius: 10px;
  font-size: 20px;
  line-height: 32px;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease;
}

.editor-close:hover {
  background: rgba(239, 68, 68, 0.14);
  color: #b91c1c;
}

.editor-tabs-bar {
  /* 原 grid -> pill 容器 */
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 6px;
  background: #f3f4f6;
  border: 1px solid #e5e7eb;
  border-radius: 999px;
  margin: 0 10px 16px;
  /* 不再使用下边框分隔 */
  box-shadow: inset 0 0 0 1px rgba(255,255,255,0.4);
}

.editor-tab-btn {
  flex: 1;
  border: 1px solid transparent;
  background: transparent;
  color: #111827;
  font-size: 14px;
  font-weight: 500;
  padding: 10px 0;
  border-radius: 999px;
  cursor: pointer;
  line-height: 1;
  transition: background .18s ease, color .18s ease, border-color .18s ease;
}

.editor-tab-btn:hover {
  background: #ffffff;
  border-color: #e2e8f0;
}

.editor-tab-btn.active {
  background: #ffffff;
  color: #111827;
  border-color: #e2e8f0;
  box-shadow: 0 1px 2px rgba(0,0,0,0.04);
}

.editor-tab-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px #ffffff, 0 0 0 4px rgba(99,102,241,0.5);
}

/* 移除旧的橙色高亮与阴影(保留兼容, 若样式缓存仍存在则覆盖) */
.editor-tab-btn.active {
  /* 复写旧样式 */
  color: #111827;
}

.editor-panel {
  padding: 24px 28px;
  overflow-y: auto;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 22px;
}


/* 精准匹配 Figma 的 新规格弹窗样式 */
.spec-modal-mask {
  position: fixed;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.28);
  z-index: 1200;
}
.spec-modal {
  width: 420px;
  max-width: calc(100% - 40px);
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #ff7a1f;
  box-shadow: 0 12px 40px rgba(17, 24, 39, 0.12);
  overflow: hidden;
}
.spec-modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 18px;
  border-bottom: 1px solid rgba(17,24,39,0.04);
}
.spec-modal-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: #111827;
}
.spec-modal .modal-close {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  border: none;
  background: #f3f4f6;
  color: #374151;
  cursor: pointer;
  font-size: 18px;
}
.spec-modal-body {
  padding: 16px 18px 8px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.spec-modal .form-field input {
  background: #f3f4f6;
  border: 1px solid #e6e9ef;
  border-radius: 8px;
  padding: 12px;
  font-size: 14px;
  color: #111827;
}
.modal-options {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 4px;
}
.option-row-modal {
  display: grid;
  grid-template-columns: 1fr 96px 32px;
  gap: 8px;
  align-items: center;
}
.option-row-modal .option-name,
.option-row-modal .option-price {
  padding: 10px 12px;
  border-radius: 8px;
  border: 1px solid #e6e9ef;
  background: #f3f4f6;
  font-size: 14px;
  color: #111827; 
}
.option-row-modal .option-name:focus,
.option-row-modal .option-price:focus {
  outline: none;
  border-color: #f97316;
}
.option-row-modal .remove-option-btn {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: #f3f4f6;
  color: #374151;
  border: none;
  font-size: 14px;
  cursor: pointer;
}
.spec-modal .add-option-block {
  width: 100%;
  padding: 10px;
  border-radius: 8px;
  border: 1px dashed #d1d5db;
  background: #ffffff;
  text-align: center;
  cursor: pointer;
  color: #374151;
}
.spec-modal-footer {
  display: flex;
  gap: 12px;
  padding: 14px 18px;
  border-top: 1px solid rgba(17,24,39,0.04);
  background: #ffffff;
}
.spec-modal-footer .btn-neutral {
  flex: 1;
  background: #ffffff;
  border: 1px solid #e6e9ef;
  color: #374151;
  padding: 10px 16px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
}
.spec-modal-footer .btn-neutral:hover { background: #f8fafc }
.spec-modal-footer .btn-orange {
  flex: 1;
  background: linear-gradient(180deg,#ff7a1f 0%,#ff8d3b 100%);
  border: none;
  color: #fff;
  padding: 10px 16px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 700;
}
.spec-modal-footer .btn-orange:active { transform: translateY(1px) }

/* 下架原因/下架信息弹窗 */
.off-shelf-mask {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 60;
}

.off-shelf-modal {
  width: min(720px, calc(100vw - 48px));
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 24px 60px rgba(15, 23, 42, 0.18);
  padding: 18px 20px 16px;
}

.off-shelf-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 10px;
}

.off-shelf-title {
  display: flex;
  align-items: center;
  gap: 10px;
}

.off-shelf-title h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #0f172a;
}

.off-shelf-icon {
  width: 18px;
  height: 18px;
  border-radius: 4px;
  background: rgba(249, 115, 22, 0.18);
  border: 1px solid rgba(249, 115, 22, 0.35);
  display: inline-block;
}

.off-shelf-close {
  border: none;
  background: rgba(15, 23, 42, 0.06);
  width: 34px;
  height: 34px;
  border-radius: 10px;
  cursor: pointer;
  font-size: 18px;
  line-height: 34px;
}

.off-shelf-desc {
  margin: 0 0 14px;
  color: #475569;
  font-size: 13px;
  line-height: 1.55;
}

.off-shelf-section-title {
  font-size: 13px;
  font-weight: 700;
  color: #0f172a;
  margin-bottom: 8px;
}

.off-shelf-radio {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 8px;
  border-radius: 10px;
  cursor: pointer;
  user-select: none;
}

.off-shelf-radio:hover {
  background: rgba(15, 23, 42, 0.04);
}

.off-shelf-radio input {
  accent-color: #f47106;
}

.off-shelf-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 14px;
}

.off-shelf-info-modal {
  padding-bottom: 18px;
}

.off-shelf-info-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 12px;
  margin-top: 12px;
}

.off-shelf-info-card {
  border: 1px solid rgba(226, 232, 240, 0.9);
  background: #f8fafc;
  border-radius: 14px;
  padding: 12px 14px;
}

.off-shelf-info-label {
  font-size: 12px;
  color: #64748b;
  margin-bottom: 6px;
}

.off-shelf-info-value {
  font-size: 14px;
  color: #0f172a;
  font-weight: 600;
}

.media-uploader {
  border: 2px dashed #d1d5db;
  border-radius: 14px;
  background: transparent;
  min-height: 140px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
  color: #9ca3af;
  font-size: 14px;
  cursor: pointer;
  transition: border 0.2s ease, color 0.2s ease, background 0.2s ease;
}

.media-uploader:hover,
.media-uploader.dragging {
  border-color: rgba(249, 115, 22, 0.55);
  color: #f97316;
  background: rgba(249, 115, 22, 0.08);
}

.media-uploader svg {
  width: 34px;
  height: 34px;
}

.media-remove {
  position: absolute;
  top: 10px;
  right: 10px;
  border: none;
  background: rgba(248, 113, 113, 0.92);
  color: #fff;
  width: 26px;
  height: 26px;
  border-radius: 50%;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease;
}

.media-remove:hover {
  background: rgba(220, 38, 38, 0.96);
  transform: scale(1.08);
}


.editor-actions {
  padding: 18px 28px 24px;
  border-top: 1px solid #f1f5f9;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  background: #ffffff;
}

.btn-neutral,
.btn-orange {
  border: none;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  padding: 10px 22px;
  cursor: pointer;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.btn-neutral {
  background: #eef2ff;
  color: #4c51bf;
}

.btn-neutral:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 18px rgba(76, 81, 191, 0.18);
}

.btn-orange {
  background: linear-gradient(120deg, #ff7a1f, #ff9f43);
  color: #ffffff;
  box-shadow: 0 16px 32px rgba(255, 122, 31, 0.32);
}

.btn-orange:hover {
  transform: translateY(-1px);
  box-shadow: 0 18px 36px rgba(255, 122, 31, 0.38);
}

.required-sign {
  color: #ef4444;
  font-weight: 600;
}

/* 新的样式 - 基于Figma设计 */
.form-group {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-field.required {
  position: relative;
}

.required-star {
  color: #ef4444;
  font-weight: 600;
  margin-left: 2px;
}

.field-label {
  font-size: 14px;
  font-weight: 600;
  color: #374151;
}

.form-field input,
.form-field select,
.form-field textarea {
  border: 1px solid #d1d5db;
  border-radius: 8px;
  padding: 10px 12px;
  font-size: 14px;
  background: #ffffff;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.form-field input:focus,
.form-field select:focus,
.form-field textarea:focus {
  outline: none;
  border-color: #f97316;
  box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
}

/* Auto-price helper spacing */
.auto-price-input { margin-bottom: 1px; }
.auto-price-hint { margin-top: 1px; margin-left: 10px; font-size: 11px; color: #6b7280; line-height: 1.2 }

.media-upload-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  margin-top: 24px;
}

.media-upload-block {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.media-label {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.upload-hint {
  font-size: 12px;
  color: #6b7280;
}


/* 开关组件样式 */
.switch-control {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 0;
}

.switch-info h4 {
  margin: 0 0 4px 0;
  font-size: 16px;
  font-weight: 600;
  color: #111827;
}

.switch-info p {
  margin: 0;
  font-size: 14px;
  color: #6b7280;
}

.switch {
  position: relative;
  display: inline-block;
  width: 48px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #d1d5db;
  transition: 0.3s;
  border-radius: 24px;
}

.slider:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: 0.3s;
  border-radius: 50%;
}

input:checked + .slider {
  background-color: #f97316;
}

input:checked + .slider:before {
  transform: translateX(24px);
}

/* 价格标签页样式 */
.price-section,
.multi-spec-section,
.discount-section {
  margin-bottom: 32px;
}

.spec-management {

  border-radius: 8px;
  padding: 0x;
  margin-top: 16px;
}

.specs-list h5 {
  margin: 0 0 12px 0;
  font-size: 14px;
  font-weight: 600;
  color: #374151;
}

.new-spec-form {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.spec-card {
  background: white;
  border: 1px solid #f1f5f9;
  border-radius: 12px;
  padding: 14px;
  margin-bottom: 12px;
}
.spec-card .form-field input {
  background: #f3f4f6;
  border: 1px solid #e6e9ef;
}
.spec-options-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 12px;
}
.option-row {
  display: grid;
  grid-template-columns: 1fr 96px 32px;
  gap: 8px;
  align-items: center;
}
.option-name, .option-price {
  padding: 8px 10px;
  border-radius: 8px;
  border: 1px solid #e6e9ef;
  background: #f3f4f6;
}
.add-option-block {
  width: 100%;
  padding: 10px;
  border-radius: 8px;
  border: 1px dashed #d1d5db;
  background: #ffffff;
  text-align: center;
  cursor: pointer;
}
.spec-footer {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  margin-top: 12px;
}
.spec-footer .btn-neutral { flex: 1 }
.spec-footer .btn-orange { flex: 1 }

.new-spec-form input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
}
.new-spec-form input:focus {
  outline: none;
  border-color: #f97316;
  box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
}

/* 外层矩形 + 内部按钮（与截图一致） */
.add-spec-container {
  border: 1px solid #eef2f6;
  border-radius: 12px;
  padding: 12px;
  background: transparent;
}

.add-spec-btn {
  width: 100%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 14px 18px;
  background: #ffffff;
  border: 1px solid #eef2f6;
  color: #111827;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  margin: 0 auto;
}

.add-spec-btn .plus {
  display: inline-flex;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  color: #111827;
  font-weight: 700;
  align-items: center;
  justify-content: center;
  font-size: 18px;
}

.add-spec-btn .add-spec-label {
  text-align: center;
  color: #111827;
  font-weight: 600;
  letter-spacing: 0.2px;
}

.add-spec-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 20px rgba(15, 23, 42, 0.06);
}

.spec-item {
  background: white;
  border: 1px solid #f97316;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 12px;
}

.spec-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.spec-name {
  font-weight: 600;
  color: #374151;
}

.remove-spec-btn {
  width: 24px;
  height: 24px;
  border: none;
  background: #f97316;
  color: white;
  border-radius: 50%;
  font-size: 16px;
  cursor: pointer;
}

.spec-options {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.spec-option {
  display: grid;
  grid-template-columns: 1fr 80px 24px;
  gap: 8px;
  align-items: center;
}

.spec-option input {
  padding: 6px 10px;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  font-size: 13px;
}

.remove-option-btn {
  width: 20px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  height: 20px;
  border: none;
  background: #ef4444;
  color: white;
  border-radius: 50%;
  font-size: 12px;
  cursor: pointer;
}

.add-option-btn {
  padding: 6px 12px;
  background: #f3f4f6;
  color: #374151;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
  align-self: flex-start;
}

/* 折扣样式 */
.discount-options {
  background: #f9fafb;
  border-radius: 8px;
  padding: 20px;
  margin-top: 16px;
}

.discount-methods {
  display: flex;
  gap: 20px;
  margin-bottom: 16px;
}

.radio-option {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  cursor: pointer;
}

.percentage-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 16px;
}

.percentage-btn {
  padding: 6px 12px;
  background: white;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.percentage-btn:hover {
  border-color: #f97316;
  color: #f97316;
}

/* 库存标签页样式 */
.stock-section {
  margin-bottom: 32px;
}

.stock-alert-section {
  margin-bottom: 32px;
}

.stock-alert-settings {
  background: #f9fafb;
  border-radius: 8px;
  padding: 20px;
  margin-top: 16px;
}

/* 其他设置标签页样式 */
.setting-cards {
  display: grid;
  gap: 16px;
  margin-bottom: 32px;
}

.setting-card {
  background: #f9fafb;
  border-radius: 8px;
  padding: 20px;
}

.status-selector {
  margin-left: auto;
}

.status-selector select {
  padding: 8px 12px;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  background: white;
  font-size: 14px;
  color: #374151;
  cursor: pointer;
  min-width: 120px;
}

.status-selector select:focus {
  outline: none;
  border-color: #f97316;
  box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
}

.business-hours-section h4 {
  margin: 0 0 16px 0;
  font-size: 16px;
  font-weight: 600;
  color: #374151;
}

.time-slots {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.time-slot {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #f9fafb;
  border-radius: 8px;
}

.time-label {
  min-width: 60px;
  font-size: 14px;
  font-weight: 500;
  color: #374151;
}

.time-input {
  padding: 6px 10px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
  font-size: 14px;
}

.time-separator {
  color: #6b7280;
  font-weight: 500;
}

.switch.small {
  width: 40px;
     height: 20px;
}

.switch.small .slider:before {
  height: 14px;
  width: 14px;
  left: 3px;
  bottom: 3px;
}

.switch.small input:checked + .slider:before {
  transform: translateX(20px);
}

.category-select-stack {
  display: flex;
  flex-direction: column;
  gap: 12px;
}




.category-select-row {
  display: flex;
  flex-wrap: nowrap;
  gap: 12px;
   align-items: center;
}

.category-select-row select {
  flex: 1 1 auto;
  min-width: 0;
}

.category-create-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 42px;
  height: 42px;
  padding: 0;
  border-radius: 12px;
  border: 1px solid #dbeafe;
  background: #f6f8ff;
  color: #19191a;
  cursor: pointer;
  transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease, opacity 0.2s ease;
  box-shadow: none;
}

.category-create-btn:hover:not(:disabled) {
  background: #cdcfda;
  border-color: #bdbec0;
  color: #000309;
}

.category-create-btn:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}

.category-create-btn .icon-plus {
  width: 18px;
  height: 18px;
  background-color: currentColor;
  mask: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M9 3v12M3 9h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>') no-repeat center / contain;
  -webkit-mask: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M9 3v12M3 9h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>') no-repeat center / contain;
}

.category-select-row select.placeholder {
  color: #9ca3af;
}

.category-select-row select:not(.placeholder) {
  color: #1f2937;
}

.category-create-inline {
  display: flex;
  align-items: center;
  gap: 12px;
}

.category-create-inline .primary-ghost-btn {
  min-width: 88px;
  padding: 9px 20px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(120deg, #ff7a1f, #ff9f43);
  color: #ffffff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 12px 22px rgba(255, 122, 31, 0.28);
  transition: transform 0.18s ease, box-shadow 0.18s ease, filter 0.18s ease;
}

.category-create-inline .primary-ghost-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 16px 30px rgba(255, 122, 31, 0.36);
  filter: brightness(0.97);
}

.category-create-inline .ghost-outline-btn {
  min-width: 88px;
  padding: 9px 20px;
  border-radius: 12px;
  border: 1px solid #d1d5db;
  background: #ffffff;
  color: #4b5563;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.18s ease, color 0.18s ease;
  box-shadow: none;
}

.category-create-inline .ghost-outline-btn:hover {
  background: #f3f4f6;
  color: #1f2937;
}

/* 库存预警样式 */
.stock-alerts-container {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 400px;
}

.stock-alert-item {
  background: #fee2e2;
  border: 1px solid #985858;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
  display: flex;
  align-items: flex-start;
  gap: 12px;
  animation: slideInRight 0.3s ease-out;
}

@keyframes slideInRight {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.alert-icon {
  font-size: 24px;
  line-height: 1;
  flex-shrink: 0;
}

.alert-content {
  flex: 1;
  min-width: 0;
}

.alert-title {
  font-size: 14px;
  font-weight: 600;
  color: #991b1b;
  margin-bottom: 4px;
}

.alert-message {
  font-size: 13px;
  color: #7f1d1d;
  line-height: 1.5;
}

.alert-message strong {
  font-weight: 600;
  color: #991b1b;
}

.alert-close {
  width: 24px;
  height: 24px;
  border: none;
  background: transparent;
  color: #991b1b;
  font-size: 24px;
  line-height: 1;
  cursor: pointer;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: background-color 0.2s;
  flex-shrink: 0;
}

.alert-close:hover {
  background: rgba(153, 27, 27, 0.1);
}

/* Toast Notification Styles */
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 16px 24px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 2000;
  animation: slideIn 0.3s ease;
  font-size: 15px;
  font-weight: 500;
  color: white;
  max-width: 400px;
  word-wrap: break-word;
}

.toast.success {
  background: #2ecc71;
}

.toast.error {
  background: #e74c3c;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

@keyframes slideOut {
  from {
    transform: translateX(0);
    opacity: 1;
  }
  to {
    transform: translateX(100%);
    opacity: 0;
  }
}

.image-upload-grid {
  display: flex;
  gap: 12px;
  align-items: flex-start;
}
.media-thumb-box {
  width: 96px;
}
.media-thumb.primary {
  width: 96px;
  height: 96px;
  border-radius: 12px;
  overflow: hidden;
  position: relative;
  background: linear-gradient(90deg, #ff7a1f, #ff9f43);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 12px 24px rgba(255, 122, 31, 0.18);
}
.media-thumb.primary.placeholder {
  background: #fff7ed;
  border: 2px dashed rgba(249,115,22,0.5);
  color: #f97316;
}
.media-thumb.primary img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.media-tag {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(255,255,255,0.06);
  color: #fff;
  font-size: 12px;
  text-align: center;
  padding: 6px 0;
}
.media-remove {
  position: absolute;
  top: 6px;
  right: 6px;
  border: none;
  background: rgba(239,68,68,0.9);
  color: #fff;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  font-size: 14px;
  cursor: pointer;
}
.uploader-placeholder {
  flex: 1;
  min-width: 140px;
}
.media-uploader {
  border: 2px dashed #d1d5db;
  border-radius: 12px;
  min-height: 96px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
  background: #fff;
}
.media-uploader svg { width: 28px; height: 28px; }
.placeholder-inner { color: #f97316; font-weight: 600; }

/* 库存预警样式 */
.stock-alerts-container {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 9999;
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-width: 400px;
}

.stock-alert-item {
  background: #fee2e2;
  border: 2px solid #ef4444;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
  display: flex;
  align-items: flex-start;
  gap: 12px;
  animation: slideInRight 0.3s ease-out;
}

@keyframes slideInRight {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.alert-icon {
  font-size: 24px;
  line-height: 1;
  flex-shrink: 0;
}

.alert-content {
  flex: 1;
  min-width: 0;
}

.alert-title {
  font-size: 14px;
  font-weight: 600;
  color: #991b1b;
  margin-bottom: 4px;
}

.alert-message {
  font-size: 13px;
  color: #7f1d1d;
  line-height: 1.5;
}

.alert-message strong {
  font-weight: 600;
  color: #991b1b;
}

.alert-close {
  width: 24px;
  height: 24px;
  border: none;
  background: transparent;
  color: #991b1b;
  font-size: 24px;
  line-height: 1;
  cursor: pointer;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: background-color 0.2s;
  flex-shrink: 0;
}

.alert-close:hover {
  background: rgba(153, 27, 27, 0.1);
}

/* Single uploader styles (merged box) */
.image-upload-area { display: flex; gap: 12px; }
.single-uploader {
  border: 2px dashed #d1d5db;
  border-radius: 12px;
  width: 160px;
  height: 96px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  cursor: pointer;
  background: #fff;
}
.single-uploader:hover,
.single-uploader.dragging { border-color: #f97316; }
.single-uploader .placeholder-inner { color: #9ca3af; font-weight: 600; }
.uploader-preview {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 10px;
  display: block;
}
.single-uploader .media-tag {
  position: absolute;
  bottom: 6px;
  left: 6px;
  background: rgba(255,122,31,0.95);
  color: white;
  padding: 4px 8px;
  border-radius: 8px;
  font-size: 12px;
}
</style>
