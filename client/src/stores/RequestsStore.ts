import { defineStore } from "pinia"
import type { Request } from "../models/Request"

export let useRequestsStore = defineStore("requests", {
  state: () =>
    ({
      requests: [],
    }) as {
      requests: Request[]
    },
  actions: {
    addRequest(request: Request) {
      this.requests.push(request)
    },
    // removeRequest(request) {
    //   this.requests.splice(this.requests.indexOf(request), 1)
    // },
  },
})
