<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"
import HttpVerb from "@/components/HttpVerb.vue"
import RequestTimings from "@/components/RequestTimings.vue"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="flex items-center justify-between">
    <div class="flex item-center space-x-2 py-2 border-0">
      <http-verb :verb="request.meta.method" />
      <span>{{ request.meta.path }}</span>
    </div>

    <div>
      <request-timings :current-request="request" />
    </div>
  </div>
</template>
