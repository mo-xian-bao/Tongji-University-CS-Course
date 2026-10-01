<template>
  <div class="content-wrapper">
    <div class="category-nav">
      <div
        v-for="category in categories"
        :key="category.id"
        class="category-item"
        :class="{ active: activeCategory === category.id }"
        @click="selectCategory(category.id)"
      >
        {{ category.name }}
      </div>
    </div>

    <div class="content-area" ref="contentAreaRef" @scroll="handleScroll">
      <div class="dishes-list">
        <div
          v-for="category in categories"
          :key="category.id"
          class="category-section"
          :ref="el => setCategoryRef(el, category.id)"
        >
          <h3 class="category-title">{{ category.name }}</h3>
          <div
            v-for="dish in getDishesByCategory(category.id)"
            :key="dish.id"
            class="dish-item"
          >
            <img 
              :src="dish.image" 
              :alt="dish.name" 
              class="dish-image"
              @error="handleDishImageError"
            >
            <div class="dish-info">
              <h3 class="dish-name">{{ dish.name }}</h3>

              <div class="dish-price">¥{{ dish.price }}</div>
            </div>
            <div class="dish-actions">
              <div v-if="getDishQuantity(dish.id) > 0" class="quantity-control">
                <button class="quantity-btn minus" @click.stop="handleDecrease(dish.id)">
                  -
                </button>
                <span class="quantity">{{ getDishQuantity(dish.id) }}</span>
                <button class="quantity-btn plus" @click.stop="handleDishSelect(dish)">
                  +
                </button>
              </div>
              <button v-else-if="hasSpecifications(dish)" class="spec-btn" @click.stop="handleDishSelect(dish)">
                选规格
              </button>
              <button v-else class="add-btn" @click.stop="handleDishSelect(dish)">
                +
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <DishOptionsModal
      :visible="showOptionsModal"
      :dish="currentDish"
      @close="showOptionsModal = false"
      @confirm="handleConfirmOptions"
    />
  </div>
</template>

<script setup>
import { ref, toRefs, watch } from 'vue'
import DishOptionsModal from './components/DishOptionsModal.vue';

const handleDishImageError = (e) => {
  e.target.src = `${typeof API_url !== 'undefined' ? API_url : ''}/static/default/dish.png`
}

const props = defineProps({
  categories: {
    type: Array,
    required: true
  },
  dishes: {
    type: Array,
    required: true
  },
  activeCategory: {
    type: Number,
    required: true
  },
  selectedDishes: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:activeCategory', 'selectDish', 'decrease-quantity'])

const showOptionsModal = ref(false);
const currentDish = ref(null);

// 获取菜品在购物车中的总数量（包含所有不同配置）
const getDishQuantity = (dishId) => {
  const items = props.selectedDishes.filter(item => item.dish_id === dishId || item.id === dishId)
  return items.reduce((total, item) => total + item.quantity, 0)
}

// 减少菜品数量
const handleDecrease = (dishId) => {
  emit('decrease-quantity', dishId)
}

const { categories, dishes, activeCategory } = toRefs(props)

const contentAreaRef = ref(null)
const categoryRefs = ref({})
const isScrolling = ref(false)

watch(categories, () => {
  categoryRefs.value = {}
})

const setCategoryRef = (el, categoryId) => {
  if (el) {
    categoryRefs.value[categoryId] = el
  }
}

const getDishesByCategory = (categoryId) => {
  return dishes.value.filter(dish => dish.categoryId === categoryId)
}

const handleScroll = () => {
  if (isScrolling.value) return

  const contentArea = contentAreaRef.value
  if (!contentArea) return

  let currentCategory = categories.value[0]?.id ?? null

  for (const category of categories.value) {
    const categoryEl = categoryRefs.value[category.id]
    if (!categoryEl) continue

    const rect = categoryEl.getBoundingClientRect()
    const containerRect = contentArea.getBoundingClientRect()
    const relativeTop = rect.top - containerRect.top

    if (relativeTop <= 100 && relativeTop >= -50) {
      currentCategory = category.id
      break
    }

    if (relativeTop <= 0 && rect.bottom - containerRect.top > 0) {
      currentCategory = category.id
    }
  }

  if (currentCategory !== null && currentCategory !== activeCategory.value) {
    emit('update:activeCategory', currentCategory)
  }
}

const selectCategory = (categoryId) => {
  const categoryEl = categoryRefs.value[categoryId]
  const contentArea = contentAreaRef.value

  if (categoryEl && contentArea) {
    isScrolling.value = true
    emit('update:activeCategory', categoryId)

    const containerRect = contentArea.getBoundingClientRect()
    const categoryRect = categoryEl.getBoundingClientRect()
    const relativeTop = categoryRect.top - containerRect.top + contentArea.scrollTop

    contentArea.scrollTo({
      top: relativeTop - 10,
      behavior: 'smooth'
    })

    setTimeout(() => {
      isScrolling.value = false
    }, 600)
  }
}

const handleDishSelect = (dish) => {
  // 检查是否有规格设置（新规格或旧规格）
  if (hasSpecifications(dish)) {
    currentDish.value = dish;
    showOptionsModal.value = true;
  } else {
    // 无规格直接加入购物车
    emit('selectDish', dish);
  }
}

const handleConfirmOptions = (selectedDish) => {
  emit('selectDish', selectedDish);
  showOptionsModal.value = false;
}

// 检查菜品是否有规格设置
const hasSpecifications = (dish) => {
  // 检查新规格系统
  if (dish.multi_spec_enabled && dish.specifications && dish.specifications.length > 0) {
    return true;
  }
  // 检查旧规格系统（辣度和葱花香菜）
  if (dish.is_spicy_selectable || dish.is_garnish_selectable) {
    return true;
  }
  return false;
}
</script>

<style scoped>
.content-wrapper {
  display: flex;
  min-height: calc(100vh - 350px);
}

.category-nav {
  width: 90px;
  background-color: #f8f8f8;
  flex-shrink: 0;
  overflow-y: auto;
  position: sticky;
  top: 112px;
  align-self: flex-start;
  max-height: calc(100vh - 112px);
}

.category-item {
  padding: 16px 12px;
  text-align: center;
  font-size: 13px;
  color: #666;
  cursor: pointer;
  position: relative;
  background-color: #f8f8f8;
  transition: all 0.3s;
}

.category-item.active {
  background-color: white;
  color: #333;
  font-weight: 600;
}

.category-item.active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 20px;
  background-color: #FF6B35;
  border-radius: 0 2px 2px 0;
}

.content-area {
  flex: 1;
  background-color: white;
  overflow-y: auto;
  max-height: calc(100vh - 112px);
  scroll-behavior: smooth;
}

.dishes-list {
  padding: 0;
}

.category-section {
  margin-bottom: 8px;
}

.category-title {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  padding: 12px 16px 8px 16px;
  margin: 0;
  background-color: #f8f8f8;
  position: sticky;
  top: 0;
  z-index: 10;
  border-bottom: 1px solid #e8e8e8;
}

.dish-item {
  display: flex;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid #f5f5f5;
  gap: 12px;
  cursor: pointer;
  position: relative;
  background-color: white;
}

.dish-item:last-child {
  border-bottom: none;
}

.dish-image {
  width: 90px;
  height: 90px;
  object-fit: cover;
  border-radius: 8px;
  flex-shrink: 0;
}

.dish-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.dish-name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin: 0;
  line-height: 1.4;
}

.dish-sales {
  font-size: 12px;
  color: #999;
}

.dish-price {
  font-size: 16px;
  color: #FF6B35;
  font-weight: bold;
}

.dish-actions {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: auto;
  align-self: flex-end;
}

.add-btn {
  width: 24px;
  height: 24px;
  background-color: #FF6B35;
  color: white;
  border: none;
  border-radius: 50%;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  flex-shrink: 0;
  line-height: 1;
  padding: 0;
}

.spec-btn {
  padding: 6px 12px;
  background-color: #FF6B35;
  color: white;
  border: none;
  border-radius: 16px;
  font-size: 13px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  flex-shrink: 0;
  white-space: nowrap;
  transition: all 0.3s;
}

.spec-btn:hover {
  background-color: #ff855a;
  transform: scale(1.05);
}

.quantity-control {
  display: flex;
  align-items: center;
  background-color: #fff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.quantity-btn {
  width: 28px;
  height: 28px;
  border: none;
  background-color: transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 18px;
  color: #333;
  transition: background-color 0.3s;
}

.quantity-btn:hover {
  background-color: #f5f5f5;
}

.quantity {
  min-width: 30px;
  text-align: center;
  font-size: 14px;
  padding: 0 4px;
}

@media (max-width: 768px) {
  .content-wrapper {
    flex-direction: row;
  }

  .category-nav {
    width: 80px;
  }

  .category-item {
    padding: 14px 8px;
    font-size: 12px;
  }
}
</style>
