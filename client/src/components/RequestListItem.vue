<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"
import HttpVerb from "@/components/ui/HttpVerb.vue"
import StatusCode from "@/components/ui/StatusCode.vue"
import Timing from "@/components/ui/Timing.vue"
import { ArrowsUpDownIcon, CircleStackIcon, HomeIcon } from "@heroicons/vue/16/solid"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="flex items-center justify-between">
    <div class="flex item-center space-x-2 py-2 border-0">
      <status-code :code="request.meta.status" />
      <http-verb :verb="request.meta.method" />
      <span>{{ request.meta.path }}</span>
    </div>

    <div class="flex space-x-3">
      <div class="flex items-center">
        <circle-stack-icon class="text-stone-600 size-3" />
        <span class="px-1 py-0.5 rounded text-sm" title="DB Queries" v-text="request.queryCount"></span>
      </div>

      <div class="flex items-center">
        <home-icon class="text-stone-600 size-3" />
        <span class="px-1 py-0.5 rounded text-sm" title="Models" v-text="request.modelsCount"></span>
      </div>

      <timing
        :duration-ms="request.meta.duration"
        :too-slow-threshold="1000"
        :slow-threshold="750"
        title="Total duration"
      >
        <arrows-up-down-icon class="text-stone-800 size-4" />
      </timing>
    </div>
  </div>
</template>
