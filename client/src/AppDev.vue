<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { onMounted } from "vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequestData } from "@/models/Request.ts"

onMounted(() => {
  if (import.meta.env.DEV && import.meta.env.VITE_LOAD_FIXTURES) {
    const requests = import.meta.glob("../../fixtures/requests/*.json", { eager: true })
    const lastId = useRequestsStore()
      .addRequests(Object.values(requests) as BackendRequestData[])
      .pop()
    useRequestsStore().setCurrentRequestById(lastId)
  }
})
</script>

<template>
  <debugbar />
</template>
