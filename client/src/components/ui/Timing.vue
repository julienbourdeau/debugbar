<script setup lang="ts">
import { computed } from "vue"

const props = withDefaults(
  defineProps<{
    durationMs: number
    slowThreshold?: number
    tooSlowThreshold?: number
  }>(),
  { slowThreshold: 1000, tooSlowThreshold: 1500 }
)

const formattedDuration = computed(() => {
  if (props.durationMs >= 1000) {
    return (props.durationMs / 1000).toFixed(2) + "s"
  }
  return props.durationMs.toFixed(1) + "ms"
})
</script>

<template>
  <div class="flex items-center">
    <slot></slot>
    <span
      :class="{
        'px-1 py-0.5 rounded text-sm': true,
        'text-orange-600': durationMs >= props.slowThreshold && durationMs < props.tooSlowThreshold,
        'text-red-600 bg-red-100': durationMs >= props.tooSlowThreshold,
      }"
      v-text="formattedDuration"
    ></span>
  </div>
</template>
