export type DebugbarConfigOptions = {
  host: string
  port: number
  prefix: string
  channelName: string
}

export class DebugbarConfig {
  readonly options: DebugbarConfigOptions

  constructor(options: DebugbarConfigOptions) {
    this.options = Object.assign(this.defaultOptions, options)
  }

  get defaultOptions(): DebugbarConfigOptions {
    return {
      host: "127.0.0.1",
      port: 3000,
      prefix: "/_debugbar",
      channelName: "DebugbarRb::DebugbarChannel",
    }
  }

  get actionCableUrl(): string {
    return `ws://${this.options.host}:${this.options.port}${this.options.prefix}/cable`
  }
}
