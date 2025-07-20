import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/tailwind.css'
import { createPinia } from 'pinia'

// ✅ 正しくインポート
import { JenesiusVueModal } from 'jenesius-vue-modal'

const app = createApp(App)

app.use(router)
app.use(createPinia())
app.use(JenesiusVueModal) // ← Plugin 型キャスト不要

app.mount('#app')