<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { ShadowRoot, ShadowStyle } from "vue-shadow-dom"
import { onMounted } from "vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequestData } from "@/models/Request.ts"

import css from "./style.css?inline"

onMounted(() => {
  console.log(`Using debugbar in DEMO mode`)

  const requests = import.meta.glob("../../fixtures/requests/*.json", { eager: true })
  const firstId = useRequestsStore().addRequests(Object.values(requests) as BackendRequestData[])[0]

  useRequestsStore().setCurrentRequestById(firstId)
})
</script>

<template>
  <div>
    <shadow-root id="__debugbar-shadow-root">
      <debugbar></debugbar>
      <shadow-style>
        {{ css }}
      </shadow-style>
    </shadow-root>
  </div>
</template>
