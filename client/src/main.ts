import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'

import { useRequestsStore} from "./stores/RequestsStore.ts";

window.setInterval(() => {
  const store = useRequestsStore()
  store.addStr("test")
}, 2000);

const pinia = createPinia()
const app = createApp(App)

app.use(pinia)
app.mount('#app')
