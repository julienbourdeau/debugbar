<script setup lang="ts">
import { ArrowsUpDownIcon, CircleStackIcon, CpuChipIcon } from "@heroicons/vue/16/solid"
import Timing from "@/components/ui/Timing.vue"
import type { BackendRequest } from "@/models/Request.ts"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="flex space-x-2">
    <timing :duration-ms="request.meta.db_runtime" title="DB runtime">
      <circle-stack-icon class="text-stone-600 size-3" />
    </timing>

    <timing :duration-ms="request.meta.cpu_time" title="CPU time">
      <cpu-chip-icon class="text-stone-600 size-3" />
    </timing>

    <timing
      :duration-ms="request.meta.duration"
      :too-slow-threshold="1000"
      :slow-threshold="750"
      class="font-bold"
      title="Total duration"
    >
      <arrows-up-down-icon class="text-stone-800 size-4" />
    </timing>
  </div>
</template>

<style scoped></style>
