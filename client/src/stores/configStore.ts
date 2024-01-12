import { defineStore } from "pinia"
import { newDebugbarConfig } from "@/models/Config.ts"

export let useConfigStore = defineStore("config", {
  state: () => ({
    config: newDebugbarConfig(window._debugbarConfigOptions),
  }),
})
