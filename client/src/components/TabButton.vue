<script setup lang="ts">
const props = defineProps<{
  label: string
  count?: number
  isActive: boolean
}>()
</script>

<template>
  <button
    class="bug-flex bug-items-center bug-space-x-1 bug-px-3 bug-py-1.5 bug-border-0"
    :class="{
      'bug-bg-red-rails bug-text-stone-100 bug-rounded-sm': props.isActive,
      'bug-cursor-pointer': !props.isActive,
    }"
  >
    <span><slot /></span>
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
  </button>
</template>

<style scoped></style>
