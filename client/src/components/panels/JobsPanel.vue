<script setup lang="ts">
import { Job } from "@/models/Request.ts"

const props = defineProps<{
  jobs: Job[]
}>()

function formatTs(ts: number) {
  return new Date(ts * 1000).toLocaleString()
}
</script>

<template>
  <div class="bug-p-4">
    <h2>Jobs</h2>

    <table class="bug-my-4 bug-mx-6 bug-divide-y bug-divide-stone-300">
      <thead>
        <tr>
          <th
            scope="col"
            class="bug-w-36 bug-py-3.5 bug-pl-4 bug-pr-3 bug-text-left bug-text-sm bug-font-semibold bug-text-stone-900 sm:bug-pl-0"
          >
            Job
          </th>
          <th scope="col" class="bug-px-3 bug-py-3.5 bug-text-left bug-text-sm bug-font-semibold bug-text-stone-900">
            Args
          </th>
        </tr>
      </thead>
      <tbody class="bug-divide-y bug-divide-stone-200">
        <tr v-for="(v, _k) in props.jobs" :key="v.class + v.at">
          <td class="bug-whitespace-nowrap bug-py-4 bug-pr-8 bug-text-stone-900">
            <div class="bug-text-lg bug-font-bold" v-text="v.class"></div>
            <div class="bug-text-stone-600 bug-text-sm">
              <div v-text="'Queue: ' + v.queue"></div>
              <div v-text="'At: ' + formatTs(v.at)"></div>
            </div>
          </td>
          <td class="bug-whitespace-nowrap bug-px-3 bug-py-4 bug-text-sm bug-text-stone-500">
            <highlightjs language="json" :code="JSON.stringify(v.args, null, 2)" />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped></style>
