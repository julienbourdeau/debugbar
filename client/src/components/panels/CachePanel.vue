<script setup lang="ts">
import type { Cache } from "@/models/Request.ts"
import Panel from "@/components/panels/Panel.vue"

const props = defineProps<{
  cache: Cache[]
}>()
</script>

<template>
  <panel>
    <div v-if="props.cache.length == 0">
      <div class="text-gray-500">It seems that Cache wasn't used.</div>
    </div>

    <div v-for="cache in props.cache" class="flex items-center space-y-1 space-x-3">
      <div class="w-24 text-right text-gray-400">{{ cache.time }}</div>
      <div class="w-16 text-center">
        <span
          class="px-1 py-0.5 rounded text-white text-xs font-mono font-medium bg-slate-400"
          :class="{
            '!bg-emerald-500': cache.label == 'hit',
            '!bg-indigo-500': cache.label == 'write',
            '!bg-amber-400': cache.label == 'read',
            '!bg-red-400': cache.label == 'delete',
          }"
        >
          {{ cache.label }}
        </span>
      </div>
      <div class="text-gray-800">
        <div class="font-medium" v-html="cache.key"></div>
        <div class="text-gray-600" v-html="cache.transaction_id"></div>
      </div>
    </div>
  </panel>
</template>

<style scoped></style>
