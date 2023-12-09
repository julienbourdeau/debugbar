<script setup lang="ts">
const props = defineProps<{
  label: string
  count?: number
  isActive: boolean
}>()
</script>

<template>
  <div
    class="bug-px-3 bug-py-1.5 bug-cursor-pointer"
    :class="{
      'bug-bg-red-rails bug-text-stone-100 bug-rounded-sm': props.isActive,
    }"
  >
    {{ props.label }}
    <span
      v-if="props.count != undefined"
      class="bug-p-1 bug-rounded-full bug-text-xs"
      :class="{
        'bug-px-2': props.count < 10,
        'bug-bg-stone-400 bug-text-stone-100': props.count == 0,
        'bug-bg-red-rails bug-text-stone-100': props.count > 0 && !props.isActive,
        'bug-bg-stone-700': props.count > 0 && props.isActive,
      }"
      v-text="props.count"
    />
  </div>
</template>

<style scoped></style>
