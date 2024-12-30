import hljs from "highlight.js/lib/core"
import sql from "highlight.js/lib/languages/sql"
import json from "highlight.js/lib/languages/json"
import hljsVuePlugin from "@highlightjs/vue-plugin"

import { createApp } from "vue"
import { createPinia } from "pinia"

hljs.registerLanguage("sql", sql)
hljs.registerLanguage("json", json)

const pinia = createPinia()

import App from "./Devtools.vue"

createApp(App).use(hljsVuePlugin).use(pinia).mount("#__debugbar-devtools-panel")
