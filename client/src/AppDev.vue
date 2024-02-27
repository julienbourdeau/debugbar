<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { onMounted } from "vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequestData } from "@/models/Request.ts"
import { random } from "lodash"

onMounted(() => {
  if (import.meta.env.DEV && import.meta.env.VITE_LOAD_FIXTURES) {
    const requests = import.meta.glob("../../fixtures/requests/*.json", { eager: true })
    const lastId = useRequestsStore()
      .addRequests(Object.values(requests) as BackendRequestData[])
      .pop()
    useRequestsStore().setCurrentRequestById(lastId)
  }

  setTimeout(() => {
    // We use `no-cors` mode because we don't need the response, we just want to trigger the request,
    // the debugbar will receive the information related to these requests via websocket
    fetch("http://127.0.0.1:3000/post-list", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/random", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/api/jobs?name=refresh&post_id=" + random(1, 300), { mode: "no-cors" })
    // fetch("http://127.0.0.1:3000/api/jobs?name=send_email&post_id=" + random(1, 300), { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/api/errors?code=404", { mode: "no-cors" })
    // fetch("http://127.0.0.1:3000/api/errors?code=401", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/api/errors?code=500", { mode: "no-cors" })
  }, 600)
})
</script>

<template>
  <debugbar />
</template>
