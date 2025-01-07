export type BackendRequestData = {
  id: string
  meta: RequestMeta
  request: HttpRequest
  response: HttpResponse
  models: { [key: string]: number }
  queries: Query[]
  jobs: Job[]
  messages: Message[]
  cache: Cache[]
  logs: Log[]
  http_calls: HttpCall[]
}

export type RequestMeta = {
  controller: string
  action: string
  params: { [key: string]: string }
  format: string
  method: string
  path: string
  status: number
  view_runtime: number
  db_runtime: number
  duration: number
  cpu_time: number
  idle_time: number
  allocations: number
}

export type HttpRequest = {
  method: string
  url: URL
  headers: Headers
  body: string
}

export type HttpResponse = {
  status: number
  headers: Headers
  body: string
}

export type Headers = { [key: string]: string }

export type Query = {
  id: string
  name: string
  sql: string
  cached: boolean
  async: boolean
  binds: any[]
  source: string[]
  duration: number
  lock_wait: number
}

export type Job = {
  id: string
  class: string
  queue: string
  args: any[]
  successfully_enqueued: boolean
  scheduled_at?: number
  logs: string[]
}

export type Message = {
  id: string
  msg: string
  extra: any
  source: string[]
}

export type Cache = {
  time: string
  name: string
  label: string
  key: string
  store: string
  transaction_id: string
  hit?: boolean
  super_operation?: string
}

export type Log = {
  time: string
  severity: number
  severity_label: string
  message: string
  progname: string
}

export type HttpCall = {
  id: string
  request: HttpRequest
  response: HttpResponse
  [key: string]: any
}

export class BackendRequest {
  id: string
  meta: RequestMeta
  request: HttpRequest
  response: HttpResponse
  models: { [key: string]: number }
  queries: Query[]
  jobs: Job[]
  messages: Message[]
  cache: Cache[]
  logs: Log[]
  httpCalls: HttpCall[]

  constructor(data: BackendRequestData) {
    if (import.meta.env.DEV) {
      console.log(data)
    }

    this.id = data?.id || "null"
    this.meta = data?.meta || ({} as unknown as RequestMeta)
    this.request = {
      ...data?.request,
      url: data?.request?.url ? new URL(data?.request.url) : new URL("http://localhost"),
    }
    this.response = data?.response || ({} as unknown as HttpResponse)
    this.models = data?.models || {}
    this.queries = data?.queries || []
    this.jobs = data?.jobs || []
    this.messages = data?.messages || []
    this.cache = data?.cache || []
    this.logs = data?.logs || []
    this.httpCalls = (data?.http_calls || []).map((call) => ({
      ...call,
      request: {
        ...call.request,
        url: call.request?.url ? new URL(call.request.url) : new URL("http://localhost"),
      },
    }))
  }

  get modelsCount(): number {
    return Object.values(this.models).reduce((a, b) => a + b, 0)
  }

  get queryCount(): number {
    return this.queries.length
  }

  get jobsCount(): number {
    return this.jobs.length
  }

  get messagesCount(): number {
    return this.messages.length
  }

  get cacheCount(): number {
    // count unique cache message per transaction_id
    return this.cache.reduce((acc, curr) => {
      if (acc.indexOf(curr.transaction_id) === -1) {
        acc.push(curr.transaction_id)
      }
      return acc
    }, []).length
  }

  get httpCount(): number {
    return this.httpCalls.length
  }

  get routeAlias(): string {
    return `${this.meta.controller}#${this.meta.action}`
  }

  get dataForTabs(): { [key: string]: any } {
    const tabs = {
      messages: {
        label: "Debug",
        count: this.messagesCount,
      },
      models: {
        label: "Models",
        count: this.modelsCount,
      },
      queries: {
        label: "Queries",
        count: this.queryCount,
      },
      jobs: {
        label: "Jobs",
        count: this.jobsCount,
      },
      cache: {
        label: "Cache",
        count: this.cacheCount,
      },
    }

    if (this.logs.length > 0) {
      tabs["logs"] = {
        label: "Logs",
      }
    }

    if (this.httpCalls.length > 0) {
      tabs["http"] = {
        label: "Http",
        count: this.httpCount,
      }
    }

    return tabs
  }
}
