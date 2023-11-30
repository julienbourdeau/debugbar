import hljs from "highlight.js/lib/core"
import sql from "highlight.js/lib/languages/sql"
import json from "highlight.js/lib/languages/json"
import hljsVuePlugin from "@highlightjs/vue-plugin"

import { createApp } from "vue"
import { createPinia } from "pinia"

import "highlight.js/styles/github.css"
import "./style.css"

import App from "./App.vue"

hljs.registerLanguage("sql", sql)
hljs.registerLanguage("json", json)

const pinia = createPinia()

const app = createApp(App)
app.use(hljsVuePlugin)
app.use(pinia)
app.mount("#__debugbar")
