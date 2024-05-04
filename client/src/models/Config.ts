import defaultsDeep from "lodash/defaultsDeep"
import { SqlLanguage } from "sql-formatter"

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
  minimized: boolean
  activeRecord: {
    adapter: "mysql" | "postgresql" | "sql" | "sqlite"
  }
  sqlDialect: SqlLanguage
}

export type DebugbarConfig = DebugbarConfigOptions & {
  actionCableUrl: string
  pollUrl: string
}

function sqlDialect(arAdapter): SqlLanguage {
  // We use regex to handle adapter names like "mysql2", "jdbcpostgresql", etc.
  if (/mysql|triology/.test(arAdapter)) {
    return "mysql"
  } else if (/pg|postgres/.test(arAdapter)) {
    return "postgresql"
  } else if (/sqlite/.test(arAdapter)) {
    return "sqlite"
  } else {
    return "sql"
  }
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
    minimized: false,
    activeRecord: {
      adapter: "sql",
    },
  } as DebugbarConfigOptions)

  obj.actionCableUrl = `${obj.cable.url}${obj.prefix}/cable`
  obj.pollUrl = `${obj.poll.url}${obj.prefix}/poll`

  obj.sqlDialect = sqlDialect(obj.activeRecord.adapter)

  return obj
}
