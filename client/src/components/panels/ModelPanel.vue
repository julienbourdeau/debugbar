<script setup lang="ts">
const props = defineProps<{
  models: { [key: string]: Number }
}>()
</script>

<template>
  <table class="bug-my-4 bug-mx-6 bug-divide-y bug-divide-stone-300">
    <thead>
      <tr>
        <th
          scope="col"
          class="bug-w-36 bug-py-3.5 bug-pl-4 bug-pr-3 bug-text-left bug-text-sm bug-font-semibold bug-text-stone-900 sm:bug-pl-0"
        >
          Model
        </th>
        <th scope="col" class="bug-px-3 bug-py-3.5 bug-text-left bug-text-sm bug-font-semibold bug-text-stone-900">
          Count
        </th>
      </tr>
    </thead>
    <tbody class="bug-divide-y bug-divide-stone-200">
      <tr v-for="(v, k) in props.models">
        <td
          class="bug-whitespace-nowrap bug-py-4 bug-pl-4 bug-pr-3 bug-text-sm bug-font-medium bug-text-stone-900 sm:bug-pl-0"
        >
          {{ k }}
        </td>
        <td class="bug-whitespace-nowrap bug-px-3 bug-py-4 bug-text-sm bug-text-stone-500 bug-text-center">{{ v }}</td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped></style>
