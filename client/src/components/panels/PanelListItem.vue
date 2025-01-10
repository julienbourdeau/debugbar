<script setup lang="ts">
import { ChevronDownIcon } from "@heroicons/vue/16/solid"
import { reactive } from "vue"
import { capitalize } from "lodash"
import { copyToClipboard } from "@/helpers.ts"

const props = defineProps<{
  title: string
  source?: string[]
  isFormatted?: boolean
  copyableText?: string
}>()

const state = reactive({
  isOpen: true,
  showOriginFile: false,
})

defineEmits(["toggleFormatting"])
</script>

<template>
  <div>
    <div class="flex items-center space-x-4">
      <button class="flex items-center space-x-1" @click="state.isOpen = !state.isOpen">
        <chevron-down-icon class="size-4" :class="{ '-rotate-90': !state.isOpen }" />
        <span class="font-bold text-sm">{{ capitalize(props.title) }}</span>
      </button>

      <slot name="title-details" />

      <div v-if="state.isOpen">
        <span
          v-if="props.isFormatted !== undefined"
          @click="$emit('toggleFormatting')"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Format SQL query"
          v-text="props.isFormatted ? 'unformat' : 'format'"
        />
        <span
          v-if="props.copyableText"
          @click="copyToClipboard(props.copyableText)"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Copy SQL query to clipboard"
          >copy</span
        >
        <span
          v-if="props.source"
          @click="state.showOriginFile = !state.showOriginFile"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Show origin file of the query"
          >file</span
        >
        <slot name="actions" />
      </div>
    </div>

    <div v-if="state.isOpen" class="mt-4 ml-4">
      <div>
        <slot name="content" />
      </div>

      <div v-if="state.showOriginFile" class="mt-3 text-stone-400 text-sm">
        <div v-text="props.source[0]"></div>
        <div v-if="props.source.length > 1" v-for="s in props.source.slice(1)" class="pl-4" v-text="'↳ ' + s"></div>
      </div>
    </div>
  </div>
</template>
