import { defineStore } from "pinia"
import { BackendRequest, BackendRequestData } from "@/models/Request.ts"

export let useRequestsStore = defineStore("requests", {
  state: () => {
    return {
      requests: [],
      currentRequest: null,
    } as {
      requests: BackendRequest[]
      currentRequest: BackendRequest
    }
  },
  actions: {
    addRequests(requests: BackendRequest[]): string[] {
      const ids = []
      requests.forEach((r) => {
        this.requests.push(new BackendRequest(r))
        ids.push(r.id)
      })
      return ids
    },
    setCurrentRequestById(id: string) {
      this.currentRequest = this.requests.find((r) => r.id === id)!
    },
    // removeRequest(request) {
    //   this.requests.splice(this.requests.indexOf(request), 1)
    // },
  },
})

function secondRequest(): BackendRequestData {
  return {
    id: "22775dc1-b86b-46e2-bc64-9268d2462713",
    meta: {
      controller: "Rails::WelcomeController",
      action: "index",
      params: {
        controller: "rails/welcome",
        action: "index",
      },
      format: "html",
      method: "GET",
      path: "/",
      status: 200,
      view_runtime: 1.180000021122396,
      db_runtime: 0.0,
      duration: 2.8529999256134033,
      cpu_time: 2.566499999999998,
      idle_time: 0.28649992561340554,
      allocations: 1151,
    },
    models: {},
    queries: [],
  }
}
