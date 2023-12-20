export type BackendRequestData = {
  id: string
  meta: RequestMeta
  models: { [key: string]: number }
  queries: Query[]
  jobs: Job[]
  messages: Message[]
  cache: Cache[]
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
  msg: string
  extra: any
}

export type Cache = {
  name: string
  key: string
  store: string
  transaction_id: string
  hit?: boolean
  super_operation?: string
}

export class BackendRequest {
  id: string
  meta: RequestMeta
  models: { [key: string]: number }
  queries: Query[]
  jobs: Job[]
  messages: Message[]
  cache: Cache[]

  constructor(data: BackendRequestData) {
    this.id = data?.id || "null"
    this.meta = data?.meta || ({} as unknown as RequestMeta) // LOL
    this.models = data?.models || {}
    this.queries = data?.queries || []
    this.jobs = data?.jobs || []
    this.messages = data?.messages || []
    this.cache = data?.cache || []
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

  get pathWithVerb(): string {
    return `${this.meta.method.toUpperCase()} ${this.meta.path}`
  }

  get dataForTabs(): { [key: string]: any } {
    return {
      messages: {
        label: "Messages",
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
      view: {
        label: "Views",
        disabled: true,
      },
      logs: {
        label: "Logs",
        disabled: true,
      },
    }
  }
}
