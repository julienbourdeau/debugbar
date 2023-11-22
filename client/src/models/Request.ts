export type Request = {
  id: string
  meta: RequestMeta
  model: { [key as string]: number }
  queries: Query[]
}

export type RequestMeta = {
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

export type Query = {
  name: string
  sql: string
  binds: any[]
  duration: number
}
