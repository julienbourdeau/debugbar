import hljs from "highlight.js/lib/core"
import sql from "highlight.js/lib/languages/sql"
import json from "highlight.js/lib/languages/json"
import hljsVuePlugin from "@highlightjs/vue-plugin"

import { createApp } from "vue"
import { createPinia } from "pinia"
import shadow from "vue-shadow-dom"

hljs.registerLanguage("sql", sql)
hljs.registerLanguage("json", json)

const pinia = createPinia()

import App from "./App.vue"

createApp(App).use(hljsVuePlugin).use(pinia).use(shadow).mount("#__debugbar")
