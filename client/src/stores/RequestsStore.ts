import { defineStore } from "pinia"
import { BackendRequest, BackendRequestData } from "@/models/Request.ts"
import { useConfigStore } from "@/stores/configStore.ts"

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
    addRequests(requests: BackendRequestData[]): string[] {
      const ids = []
      requests.forEach((r) => {
        if (!this.requests.find((req) => req.id === r.id)) {
          this.requests.push(new BackendRequest(r))
        }
        ids.push(r.id)
      })

      while (this.requests.length > useConfigStore().config.maxRequests) {
        this.requests.shift()
      }

      return ids
    },
    setCurrentRequestById(id: string) {
      this.currentRequest = this.requests.find((r) => r.id === id)!
    },
    clearRequests() {
      this.requests = []
      this.currentRequest = null
    },
  },
})
