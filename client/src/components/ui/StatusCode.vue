<script setup lang="ts">
const props = defineProps<{
  code: number
}>()
</script>

<template>
  <span
    class="px-1 py-0.5 rounded text-xs"
    :class="{
      'bg-green-600 text-white': props.code < 300,
      'bg-blue-500 text-white': props.code >= 300 && props.code < 400,
      'bg-amber-600 text-white': props.code >= 400 && props.code < 500,
      'bg-red-600 text-white': props.code >= 500,
    }"
    v-text="props.code"
  ></span>
</template>

<style scoped></style>
