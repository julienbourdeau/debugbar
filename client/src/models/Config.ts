import defaultsDeep from "lodash/defaultsDeep"

export type DebugbarConfigOptions = {
  mode: "ws" | "poll" | "off"
  prefix: string
  cable: {
    url: string
    channelName: string
  }
  poll: {
    url: string
    interval: number
  }
  height: number
  maxRequests: number
}

export type DebugbarConfig = DebugbarConfigOptions & {
  actionCableUrl: string
  pollUrl: string
}

export function newDebugbarConfig(options: DebugbarConfigOptions) {
  const obj: DebugbarConfig = defaultsDeep(options, {
    mode: "ws",
    prefix: "/_debugbar",
    cable: {
      url: "ws://127.0.0.1:3000",
      channelName: "Debugbar::DebugbarChannel",
    },
    poll: {
      url: "http://127.0.0.1:3000",
      interval: 500,
    },
    height: 360,
    maxRequests: 25,
  } as DebugbarConfigOptions)

  obj.actionCableUrl = `${obj.cable.url}${obj.prefix}/cable`
  obj.pollUrl = `${obj.poll.url}${obj.prefix}/poll`

  return obj
}
