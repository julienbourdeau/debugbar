// Loaded directly by index.html when in development mode

import hljs from "highlight.js/lib/core"
import sql from "highlight.js/lib/languages/sql"
import json from "highlight.js/lib/languages/json"
import hljsVuePlugin from "@highlightjs/vue-plugin"

import { createApp } from "vue"
import { createPinia } from "pinia"

import "../src/style.css"

hljs.registerLanguage("sql", sql) // I don't know why my editor gives me an error here.
hljs.registerLanguage("json", json)

const pinia = createPinia()

import AppDev from "../src/AppDevtoolsDev.vue"

createApp(AppDev).use(hljsVuePlugin).use(pinia).mount("#__debugbar-devtools-panel-for-dev")
