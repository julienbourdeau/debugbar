<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"
import QueryItem from "@/components/queries/QueryItem.vue"

const props = defineProps<{
  currentRequest: BackendRequest
}>()
</script>

<template>
  <div class="flex flex-col space-y-8">
    <query-item v-for="query in props.currentRequest.queries" :key="query.id" :query="query" />
  </div>
</template>
