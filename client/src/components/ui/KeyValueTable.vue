<script setup lang="ts">
const props = defineProps<{
  keyLabel?: string
  valueLabel?: string
}>()
</script>

<template>
  <table class="break-all w-full border-separate border-spacing-1">
    <tr v-if="props.keyLabel || props.valueLabel">
      <th v-text="props.keyLabel" class="bg-amber-50 w-40 px-3 py-1"></th>
      <th v-text="props.valueLabel" class="bg-amber-50 px-3 py-1"></th>
    </tr>
    <slot />
  </table>
</template>
