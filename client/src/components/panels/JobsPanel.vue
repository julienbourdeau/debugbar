<script setup lang="ts">
import { Job } from "@/models/Request.ts"

const props = defineProps<{
  jobs: Job[]
}>()

function formatTs(ts: number) {
  if (ts == null) {
    return "-"
  }
  return new Date(ts * 1000).toLocaleString()
}
</script>

<template>
  <div class="p-4">
    <h2>Jobs</h2>

    <table class="my-4 mx-6 divide-y divide-stone-300">
      <thead>
        <tr>
          <th scope="col" class="w-36 py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-stone-900 sm:pl-0">Job</th>
          <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-stone-900">Args</th>
          <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-stone-900">Logs</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-stone-200">
        <tr v-for="(v, _k) in props.jobs" :key="v.id">
          <td class="whitespace-nowrap p-4 pr-8 text-stone-900">
            <div class="text-lg font-bold" v-text="v.class"></div>
            <div class="text-stone-600 text-sm">
              <div v-text="'Queue: ' + v.queue"></div>
              <div v-text="'At: ' + formatTs(v.scheduled_at)"></div>
            </div>
          </td>
          <td class="whitespace-nowrap px-3 p-4 pr-8 text-sm">
            <highlightjs language="json" :code="JSON.stringify(v.args, null, 2)" />
          </td>
          <td class="whitespace-nowrap px-3 p-4 pr-8 text-sm text-stone-500">
            <div v-for="(log, k) in v.logs" v-html="(k > 0 ? '&nbsp; '.repeat(k) + '↳ ' : '') + log" class="" />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped></style>
