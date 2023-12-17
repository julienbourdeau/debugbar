<script setup lang="ts">
const props = defineProps<{
  label: string
  count?: number
  isActive: boolean
}>()
</script>

<template>
  <button
    class="flex items-center space-x-1 px-3 py-1.5 border-0"
    :class="{
      'bg-red-rails text-stone-100 rounded-sm': props.isActive,
      'cursor-pointer': !props.isActive,
    }"
  >
    <span><slot /></span>
    <span
      v-if="props.count != undefined"
      class="p-1 rounded-full text-xs"
      :class="{
        'px-2': props.count < 10,
        'bg-stone-400 text-stone-100': props.count == 0,
        'bg-red-rails text-stone-100': props.count > 0 && !props.isActive,
        'bg-stone-700': props.count > 0 && props.isActive,
      }"
      v-text="props.count"
    />
  </button>
</template>

<style scoped></style>
