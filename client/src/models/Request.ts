export type BackendRequestData = {
  id: string
  meta: RequestMeta
  models: { [key: string]: number }
  queries: Query[]
}

type RequestMeta = {
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

type Query = {
  name: string
  sql: string
  binds: any[]
  source: string[]
  duration: number
  lock_wait: number
}

export class BackendRequest {
  id: string
  meta: RequestMeta
  models: { [key: string]: number }
  queries: Query[]

  constructor(data: BackendRequestData) {
    this.id = data?.id || "null"
    this.meta = data?.meta || ({} as unknown as RequestMeta) // LOL
    this.models = data?.models || {}
    this.queries = data?.queries || []
  }

  get modelsCount(): number {
    return Object.values(this.models).reduce((a, b) => a + b, 0)
  }

  get queryCount(): number {
    return this.queries.length
  }

  get pathWithVerb(): string {
    return `${this.meta.method.toUpperCase()} ${this.meta.path}`
  }

  get dataForTabs(): { [key: string]: any } {
    return {
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
        count: 0,
      },
    }
  }
}
