<script setup lang="ts">
const props = defineProps<{
  label: string
  count?: number
  isActive: boolean
}>()
</script>

<template>
  <button
    class="text-sm flex items-center space-x-1 px-2 py-1.5 border-0"
    :class="{
      'bg-stone-300 rounded-t-sm cursor-auto': props.isActive,
    }"
  >
    <span :class="{ 'font-medium': props.isActive }"><slot /></span>
    <span
      v-if="props.count != undefined"
      class="p-0.5 rounded-full text-xs"
      :class="{
        'px-1.5': props.count < 10,
        hidden: props.count == 0,
        'bg-stone-300': props.count > 0 && !props.isActive,
        'bg-stone-400': props.count > 0 && props.isActive,
        // '!bg-red-700 !text-white': props.count > 10, // TODO: Should be PER TAB (30 models is fine but 30 queries is a lot)
      }"
      v-text="props.count"
    />
  </button>
</template>

<style scoped></style>
