import { DebugbarConfig, DebugbarConfigOptions } from "@/models/Config.ts"

export {}

declare global {
  interface Window {
    _debugbarConfigOptions?: DebugbarConfigOptions
  }
}
