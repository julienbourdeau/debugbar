export type DebugbarConfigOptions = {
  cable: {
    url: string
    prefix: string
  }
  channelName: string
}

export class DebugbarConfig {
  readonly options: DebugbarConfigOptions

  constructor(options: DebugbarConfigOptions) {
    this.options = Object.assign(this.defaultOptions, options)
  }

  get defaultOptions(): DebugbarConfigOptions {
    return {
      cable: {
        url: "ws://127.0.0.1:3000",
        prefix: "/_debugbar",
      },
      channelName: "DebugbarRb::DebugbarChannel",
    }
  }

  get actionCableUrl(): string {
    const { url, prefix } = this.options.cable

    return `${url}${prefix}/cable`
  }
}
