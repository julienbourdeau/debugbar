<script setup lang="ts">
const props = defineProps<{
  models: { [key: string]: Number }
}>()
</script>

<template>
  <table class="my-4 mx-6 divide-y divide-stone-300">
    <thead>
      <tr>
        <th scope="col" class="w-36 py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-stone-900 sm:pl-0">Model</th>
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
</template>

<style scoped></style>
