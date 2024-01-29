<script setup lang="ts">
const props = defineProps<{
  label?: string
}>()
</script>

<template>
  <tr>
    <td v-text="props.label" class="w-40 font-medium bg-stone-50 px-3 py-1"></td>
    <td class="px-3 py-1"><slot /></td>
  </tr>
</template>

<style scoped></style>
