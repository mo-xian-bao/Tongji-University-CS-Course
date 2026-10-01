<template>
  <div v-if="visible" class="modal-overlay" @click.self="handleClose">
    <div class="modal-content">
      <!-- 顶部标题 -->
      <div class="modal-header">
        <h3 class="dish-name">{{ dish.name }}</h3>
        <button class="close-btn" @click="handleClose">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
        </button>
      </div>
      
      <div class="modal-body">
        <!-- 动态规格选择 -->
        <div v-if="dish.multi_spec_enabled && dish.specifications && dish.specifications.length > 0" class="specifications-container">
          <div v-for="(spec, index) in dish.specifications" :key="spec.id || index" class="spec-group">
            <h4 class="spec-title">{{ spec.name }}</h4>
            <div class="spec-options">
              <div
                v-for="(option, optIndex) in spec.options"
                :key="option.id || option.name || optIndex"
                class="spec-option"
                :class="{ selected: isOptionSelected(index, option) }"
                @click="selectSpecOption(index, option)"
              >
                <span class="option-name">{{ option.name }}</span>
                <span v-if="option.price && option.price !== 0" class="option-price">
                  ¥{{ option.price > 0 ? '+' : '' }}{{ Math.abs(option.price).toFixed(2) }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- 辣度选择（旧系统兼容） -->
        <div v-if="dish.is_spicy_selectable" class="spec-group">
          <h4 class="spec-title">辣度</h4>
          <div class="spec-options">
            <div
              v-for="option in spicyOptions"
              :key="option"
              class="spec-option"
              :class="{ selected: localSelections.spiciness === option }"
              @click="selectSpiciness(option)"
            >
              <span class="option-name">{{ option }}</span>
            </div>
          </div>
        </div>

        <!-- 葱花香菜选择（旧系统兼容） -->
        <div v-if="dish.is_garnish_selectable" class="spec-group">
          <h4 class="spec-title">葱花香菜</h4>
          <div class="spec-options">
            <div
              v-for="option in garnishOptions"
              :key="option"
              class="spec-option"
              :class="{ selected: localSelections.garnish === option }"
              @click="selectGarnish(option)"
            >
              <span class="option-name">{{ option }}</span>
            </div>
          </div>
        </div>

        <!-- 已选规格摘要 -->
        <div v-if="selectedSpecsSummary" class="selected-summary">
          <span class="summary-label">已选规格：</span>
          <span class="summary-text">{{ selectedSpecsSummary }}</span>
        </div>
      </div>

      <!-- 底部操作栏 -->
      <div class="modal-footer">
        <div class="price-section">
          <div class="price-main">¥{{ finalPrice.toFixed(2) }}</div>
          <div v-if="hasDiscount" class="price-original">¥{{ originalPrice.toFixed(2) }}</div>
        </div>
        <button class="add-to-cart-btn" @click="handleConfirm">
          <span class="btn-icon">+</span>
          <span class="btn-text">加入购物车</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  dish: {
    type: Object,
    default: () => ({})
  }
});

const emit = defineEmits(['close', 'confirm']);

const spicyOptions = ['不辣', '微辣', '中辣', '特辣', '变态辣'];
const garnishOptions = ['要葱花香菜', '要葱花', '要香菜', '不要葱花不要香菜'];

const localSelections = ref({
  spiciness: null,
  garnish: null
});

// 动态规格选择
const selectedSpecs = ref([]);

watch(() => props.visible, (newVal) => {
  if (newVal) {
    // 重置旧选择并为兼容选项填入默认值
    localSelections.value = {
      spiciness: props.dish.is_spicy_selectable ? spicyOptions[0] : null,
      garnish: props.dish.is_garnish_selectable ? garnishOptions[0] : null,
    };
    
    // 初始化规格选择：默认预选每个规格的第一项（提高体验）
    selectedSpecs.value = [];
    if (props.dish.multi_spec_enabled && props.dish.specifications) {
      props.dish.specifications.forEach(spec => {
        const firstOption = (spec.options && spec.options.length > 0) ? spec.options[0] : null;
        selectedSpecs.value.push({
          id: spec.id,
          name: spec.name,
          selectedOption: firstOption
        });
      });
    }
  }
});

// 计算最终价格
const finalPrice = computed(() => {
  let basePrice = parseFloat(props.dish.price) || 0;
  
  // 应用折扣
  if (hasDiscount.value) {
      const discount = props.dish.discount;
      if (discount.method === 'price' && discount.price !== null) {
          basePrice = parseFloat(discount.price);
      } else if (discount.method === 'percentage' && discount.percentage !== null) {
          basePrice = basePrice * parseFloat(discount.percentage);
      }
  }
  
  let price = basePrice;
  
  // 加上规格选项的额外价格
  selectedSpecs.value.forEach(spec => {
    if (spec.selectedOption && spec.selectedOption.price) {
      price += parseFloat(spec.selectedOption.price) || 0;
    }
  });
  
  return price;
});

// 原价（用于显示折扣）
const originalPrice = computed(() => {
  let price = parseFloat(props.dish.price) || 0;
  selectedSpecs.value.forEach(spec => {
    if (spec.selectedOption && spec.selectedOption.price) {
      price += parseFloat(spec.selectedOption.price) || 0;
    }
  });
  return price;
});

// 是否有折扣
const hasDiscount = computed(() => {
  const discount = props.dish.discount;
  return discount && discount.enable;
});

// 已选规格摘要文本
const selectedSpecsSummary = computed(() => {
  const parts = [];
  
  // 添加规格选项
  selectedSpecs.value.forEach(spec => {
    if (spec.selectedOption) {
      parts.push(spec.selectedOption.name);
    }
  });
  
  // 添加辣度
  if (localSelections.value.spiciness) {
    parts.push(localSelections.value.spiciness);
  }
  
  // 添加葱花香菜
  if (localSelections.value.garnish) {
    parts.push(localSelections.value.garnish);
  }
  
  return parts.join('、');
});

// 检查选项是否被选中（支持没有 id 的 option）
const isOptionSelected = (specIndex, option) => {
  const spec = selectedSpecs.value[specIndex];
  if (!spec || !spec.selectedOption) return false;
  const sel = spec.selectedOption;
  
  // 优先比较引用
  if (sel === option) return true;
  // 如果都有 id，则比较 id
  if (sel.id !== undefined && option.id !== undefined) return sel.id === option.id;
  // 如果都有 name，则比较 name
  if (sel.name !== undefined && option.name !== undefined) return sel.name === option.name;
  
  return false;
};

// 选择规格选项
const selectSpecOption = (specIndex, option) => {
  const spec = selectedSpecs.value[specIndex];
  if (!spec) return;

  // 如果点击的是当前已选中的，则取消选中
  if (isOptionSelected(specIndex, option)) {
    spec.selectedOption = null;
  } else {
    // 否则选中新的
    spec.selectedOption = option;
  }
};

const selectSpiciness = (option) => {
  localSelections.value.spiciness = option;
};

const selectGarnish = (option) => {
  localSelections.value.garnish = option;
};

const handleClose = () => {
  emit('close');
};

const handleConfirm = () => {
  emit('confirm', {
    ...props.dish,
    ...localSelections.value,
    selectedSpecs: selectedSpecs.value
  });
  handleClose();
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1001;
  animation: fadeIn 0.25s ease;
  padding: 20px;
}

@keyframes fadeIn {
  from { 
    opacity: 0; 
  }
  to { 
    opacity: 1; 
  }
}

.modal-content {
  background: white;
  border-radius: 16px;
  width: 100%;
  max-width: 480px;
  max-height: 85vh;
  display: flex;
  flex-direction: column;
  animation: scaleIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

@keyframes scaleIn {
  from { 
    transform: scale(0.9);
    opacity: 0;
  }
  to { 
    transform: scale(1);
    opacity: 1;
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 16px 16px 16px;
  background: white;
  border-radius: 16px 16px 0 0;
  border-bottom: 1px solid #f0f0f0;
}

.dish-name {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
  color: #333;
}

.close-btn {
  width: 32px;
  height: 32px;
  border: none;
  background: transparent;
  color: #666;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  border-radius: 50%;
  transition: background 0.2s;
}

.close-btn:hover {
  background: #f0f0f0;
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  background: white;
}

.specifications-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.spec-group {
  background: white;
}

.spec-title {
  font-size: 15px;
  font-weight: 600;
  margin: 0 0 12px 0;
  color: #333;
}

.spec-options {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  gap: 10px;
}

.spec-option {
  padding: 10px 12px;
  border: 1px solid #e5e5e5;
  border-radius: 8px;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  min-height: 44px;
  color: #333;
}

.spec-option:active {
  transform: scale(0.98);
}

.spec-option.selected {
  background-color: #fff;
  border-color: #FF6B35;
  color: #FF6B35;
}

.option-name {
  font-size: 14px;
  font-weight: 500;
  text-align: center;
  color: #333;
}

.spec-option.selected .option-name {
  color: #FF6B35;
  font-weight: 600;
}

.option-price {
  font-size: 12px;
  color: #999;
}

.spec-option.selected .option-price {
  color: #FF6B35;
}

.selected-summary {
  background: #f9f9f9;
  border-radius: 8px;
  padding: 14px 16px;
  margin-top: 20px;
  font-size: 13px;
  color: #666;
  line-height: 1.6;
}

.summary-label {
  color: #333;
  font-weight: 500;
}

.summary-text {
  color: #666;
}

.modal-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: white;
  border-top: 1px solid #f0f0f0;
  border-radius: 0 0 16px 16px;
  gap: 12px;
}

.price-section {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.price-main {
  font-size: 22px;
  font-weight: 700;
  color: #333;
}

.price-original {
  font-size: 13px;
  color: #999;
  text-decoration: line-through;
}

.add-to-cart-btn {
  flex: 1;
  max-width: 200px;
  height: 44px;
  background: linear-gradient(135deg, #FFD400 0%, #FFC700 100%);
  color: #333;
  border: none;
  border-radius: 22px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: all 0.2s ease;
  box-shadow: 0 2px 8px rgba(255, 212, 0, 0.3);
}

.add-to-cart-btn:active {
  transform: scale(0.98);
  box-shadow: 0 1px 4px rgba(255, 212, 0, 0.3);
}

.btn-icon {
  font-size: 18px;
  font-weight: 700;
}

.btn-text {
  font-size: 15px;
}

/* 滚动条样式 */
.modal-body::-webkit-scrollbar {
  width: 4px;
}

.modal-body::-webkit-scrollbar-track {
  background: transparent;
}

.modal-body::-webkit-scrollbar-thumb {
  background: #ddd;
  border-radius: 2px;
}

.modal-body::-webkit-scrollbar-thumb:hover {
  background: #ccc;
}
</style>