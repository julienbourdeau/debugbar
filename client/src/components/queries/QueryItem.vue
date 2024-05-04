<script setup lang="ts">
import { format } from "sql-formatter"
import { CircleStackIcon } from "@heroicons/vue/16/solid"

import { Query } from "@/models/Request.ts"
import { reactive } from "vue"
import { useConfigStore } from "@/stores/configStore.ts"
import Timing from "@/components/ui/Timing.vue"
import PanelListItem from "@/components/panels/PanelListItem.vue"

const props = defineProps<{
  query: Query
}>()

const state = reactive({
  isFormatted: false,
})

let configStore = useConfigStore()

const sqlFormat = (query: string) => {
  return format(query, { language: configStore.config.sqlDialect })
}

const reformat = (query: string) => {
  return state.isFormatted ? sqlFormat(query) : query
}
</script>

<template>
  <panel-list-item
    @toggle-formatting="state.isFormatted = !state.isFormatted"
    :title="query.name"
    :source="query.source"
    :is-formatted="state.isFormatted"
    :copyable-text="reformat(query.sql)"
  >
    <template v-slot:title-details>
      <span v-if="props.query.cached" class="px-1 py-0.5 rounded text-xs bg-sky-600 text-white">cached</span>
      <span v-if="props.query.async" class="px-1 py-0.5 rounded text-xs bg-emerald-600 text-white">async</span>
      <timing :duration-ms="props.query.duration" :slowThreshold="30" :too-slow-threshold="100" title="Query runtime">
        <circle-stack-icon class="text-stone-600 size-3" />
      </timing>
    </template>

    <template v-slot:actions> </template>

    <template v-slot:content>
      <highlightjs language="sql" :code="reformat(query.sql)" />
    </template>
  </panel-list-item>
</template>
