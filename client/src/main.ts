import hljs from "highlight.js/lib/core"
import sql from "highlight.js/lib/languages/sql"
import json from "highlight.js/lib/languages/json"
import hljsVuePlugin from "@highlightjs/vue-plugin"

import { createApp } from "vue"
import { createPinia } from "pinia"
import shadow from "vue-shadow-dom"

import "highlight.js/styles/github.css"
import "./style.css"

hljs.registerLanguage("sql", sql)
hljs.registerLanguage("json", json)

const pinia = createPinia()

import AppDev from "./AppDev.vue"
import AppDemo from "./AppDemo.vue"
import App from "./App.vue"

if (import.meta.env.VITE_DEMO_MODE) {
  createApp(AppDemo).use(hljsVuePlugin).use(pinia).use(shadow).mount("#__debugbar")
} else if (import.meta.env.DEV) {
  createApp(AppDev).use(hljsVuePlugin).use(pinia).mount("#__debugbar__DEV")
} else {
  createApp(App).use(hljsVuePlugin).use(pinia).use(shadow).mount("#__debugbar")
}
