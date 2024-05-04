<script setup lang="ts">
import { format } from "sql-formatter"
import { ChevronDownIcon, CircleStackIcon } from "@heroicons/vue/16/solid"

import { Query } from "@/models/Request.ts"
import { reactive } from "vue"
import { useConfigStore } from "@/stores/configStore.ts"
import Timing from "@/components/ui/Timing.vue"
import { copyToClipboard } from "@/helpers.ts"

const props = defineProps<{
  query: Query
}>()

const state = reactive({
  isOpen: true,
  isFormatted: false,
  showOriginFile: false,
})

let configStore = useConfigStore()

function sqlFormat(query: string) {
  return format(query, { language: configStore.config.sqlDialect })
}
</script>

<template>
  <div>
    <div class="flex items-center space-x-4">
      <button class="flex items-center space-x-1" @click="state.isOpen = !state.isOpen">
        <chevron-down-icon
          class="size-4"
          :class="{
            '-rotate-90': !state.isOpen,
          }"
        />
        <span class="font-semibold text-lg">{{ query.name }}</span>
      </button>

      <span v-if="props.query.cached" class="px-1 py-0.5 rounded text-xs bg-sky-600 text-white">cached</span>
      <span v-if="props.query.async" class="px-1 py-0.5 rounded text-xs bg-emerald-600 text-white">async</span>
      <timing :duration-ms="props.query.duration" :slowThreshold="30" :too-slow-threshold="100" title="Query runtime">
        <circle-stack-icon class="text-stone-600 size-3" />
      </timing>

      <div v-if="state.isOpen">
        <span
          @click="state.isFormatted = !state.isFormatted"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Format SQL query"
          v-text="state.isFormatted ? 'unformat' : 'format'"
        />
        <span
          @click="copyToClipboard(query.sql)"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Copy SQL query to clipboard"
          >copy</span
        >
        <span
          @click="state.showOriginFile = !state.showOriginFile"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Show origin file of the query"
          >file</span
        >
      </div>
    </div>

    <div v-if="state.isOpen" class="mt-4 ml-4">
      <div class="">
        <highlightjs language="sql" :code="state.isFormatted ? sqlFormat(query.sql) : query.sql" />
      </div>

      <div v-if="state.showOriginFile" class="mt-3 text-stone-400 text-sm">
        <div v-text="query.source[0]"></div>
        <div v-if="query.source.length > 1" v-for="s in query.source.slice(1)" class="pl-4" v-text="'↳ ' + s"></div>
      </div>
    </div>
  </div>
</template>
