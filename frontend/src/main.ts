import { createApp } from 'vue'
import App from './views/App.vue'
import router from './router'
import './assets/tailwind.css'
// import JenesiusVueModal from 'jenesius-vue-modal'
// import { createPinia } from 'pinia'


const app = createApp(App)

app.use(router)
// app.use(JenesiusVueModal)
// app.use(createPinia())

app.mount('#app')