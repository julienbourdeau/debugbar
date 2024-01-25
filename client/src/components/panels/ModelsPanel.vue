<script setup lang="ts">
import Panel from "@/components/panels/Panel.vue"

const props = defineProps<{
  models: { [key: string]: number }
  count: number
}>()
</script>

<template>
  <panel>
    <div v-if="props.count == 0">
      <div class="text-gray-500">No models were initialized.</div>
    </div>

    <table v-if="props.count > 0" class="divide-y divide-stone-300">
      <thead>
        <tr>
          <th scope="col" class="w-36 py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-stone-900 sm:pl-0">
            Model
          </th>
          <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-stone-900">Count</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-stone-200">
        <tr v-for="(v, k) in props.models" :key="k">
          <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-stone-900 sm:pl-0">
            {{ k }}
          </td>
          <td class="whitespace-nowrap px-3 py-4 text-sm text-stone-500 text-center">{{ v }}</td>
        </tr>
      </tbody>
    </table>
  </panel>
</template>

<style scoped></style>
