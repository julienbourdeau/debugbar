<script setup lang="ts">
import { Log } from "@/models/Request.ts"
import Panel from "@/components/panels/Panel.vue"

const props = defineProps<{
  logs: Log[]
}>()

function message(log: Log): string {
  const str = log.progname || log.message || ""
  return str.replace(" ", "&nbsp;&nbsp;")
}
</script>

<template>
  <panel>
    <div v-if="props.logs.length == 0">
      <div class="text-gray-500">No logs to show. Are you using the correct minimum level in your config?</div>
    </div>

    <div v-for="log in props.logs" class="flex items-center space-y-1 space-x-3">
      <div class="w-32 text-right text-gray-400">{{ log.time }}</div>
      <div class="w-20 text-center">
        <span
          class="px-1 py-0.5 rounded text-white text-xs font-mono font-medium"
          :class="{
            'bg-stone-400': log.severity == 0,
            'bg-blue-500': log.severity == 1,
            'bg-amber-400': log.severity == 2,
            'bg-red-400': log.severity == 2,
            'bg-fuchsia-500': log.severity >= 3,
          }"
          :title="log.severity_label"
        >
          {{ log.severity_label }}
        </span>
      </div>
      <div class="text-gray-800" v-html="message(log)"></div>
    </div>
  </panel>
</template>

<style scoped></style>
