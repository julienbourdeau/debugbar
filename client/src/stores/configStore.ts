import { defineStore } from "pinia"
import { DebugbarConfig } from "@/models/Config.ts"

export let useConfigStore = defineStore("config", {
  state: () => ({
    config: new DebugbarConfig(window._debugbarConfigOptions),
  }),
})
