export type BackendRequest = {
  id: string
  meta: RequestMeta
  models: { [key: string]: number }
  queries: Query[]
}

type RequestMeta = {
  controller: string
  action: string
  request: string
  params: any
  headers: string
  format: string
  method: string
  path: string
  status: number
  view_runtime: number
  db_runtime: number
}

type Query = {
  name: string
  sql: string
  binds: any[]
  duration: number
  source: string[]
}
