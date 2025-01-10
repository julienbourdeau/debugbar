<script setup lang="ts">
import Devtools from "@/devtools/Devtools.vue"
import { onMounted } from "vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequestData } from "@/models/Request.ts"

let requestsStore = useRequestsStore()

onMounted(() => {
  // We cannot use `chrome.devtools.network.onRequestFinished.addListener` because it's not available outside the extension
  // If we make Http calls to 127.0.0.1:3000 from `localhost:5173` it's a different domain. Because of CORS, we're not able
  // to retrieve the `X-Debugbar-Url` header.
  console.log(`The requests are loaded from the fixtures.`)

  const requests = import.meta.glob("../../fixtures/requests/*.json", { eager: true })
  const firstId = requestsStore.addRequests(Object.values(requests) as BackendRequestData[])[0]

  requestsStore.setCurrentRequestById(firstId)
})
</script>

<template>
  <div class="h-full">
    <devtools></devtools>
  </div>
</template>
