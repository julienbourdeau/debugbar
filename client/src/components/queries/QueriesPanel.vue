<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"
import QueryItem from "@/components/queries/QueryItem.vue"
import Panel from "@/components/panels/Panel.vue"

const props = defineProps<{
  currentRequest: BackendRequest
}>()
</script>

<template>
  <panel>
    <div class="flex flex-col space-y-8">
      <query-item v-for="query in props.currentRequest.queries" :key="query.id" :query="query" />
    </div>
  </panel>
</template>
