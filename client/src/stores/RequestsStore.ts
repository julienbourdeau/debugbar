import { defineStore } from "pinia"
import { BackendRequest } from "@/models/Request.ts"

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
        if (!this.requests.find((req) => req.id === r.id)) {
          this.requests.push(new BackendRequest(r))
        }
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
