<script setup lang="ts">
import { reactive } from "vue"
import { ChevronDownIcon } from "@heroicons/vue/16/solid"

const props = withDefaults(
  defineProps<{
    label: string
    isOpen?: boolean
  }>(),
  {
    isOpen: false,
  }
)

const state = reactive({
  isOpen: props.isOpen,
})
</script>

<template>
  <div>
    <div>
      <button class="flex items-center space-x-1" @click="state.isOpen = !state.isOpen">
        <chevron-down-icon
          class="size-4"
          :class="{
            '-rotate-90': !state.isOpen,
          }"
        />
        <span class="font-medium">{{ props.label }}</span>
      </button>
    </div>

    <div v-if="state.isOpen">
      <slot />
    </div>
  </div>
</template>
<style scoped></style>
