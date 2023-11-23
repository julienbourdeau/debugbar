<script setup lang="ts">
const props = defineProps<{
  label: string
  count: number
  isActive: boolean
}>()
</script>

<template>
  <div
    class="px-3 py-1.5 cursor-pointer"
    :class="{
      'bg-red-rails text-stone-100': props.isActive,
    }"
  >
    {{ props.label }}
    <span
      class="p-1 rounded-full text-sm"
      :class="{
        'px-2': props.count < 10,
        'bg-stone-400 text-stone-100': props.count == 0,
        'bg-red-rails text-stone-100': props.count > 0,
        '!bg-stone-100 !text-red-rails': props.isActive,
      }"
      v-text="props.count"
    />
  </div>
</template>

<style scoped></style>
