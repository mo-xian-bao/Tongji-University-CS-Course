import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

const target = 'http://localhost:5000'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      'vue-echarts': 'vue-echarts/dist/index.esm.js'
    }
  },
  server: {
    port: 3000,
    open: false,
    proxy: {
      '/api': {
        target: target,
        changeOrigin: true,
        secure: false
      }
    }
  },
  define: {
      API_url: JSON.stringify(target)
  },
})