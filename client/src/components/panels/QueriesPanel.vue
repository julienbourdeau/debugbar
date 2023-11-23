<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  currentRequest: BackendRequest
}>()
</script>

<template>
  <div class="flex flex-col space-y-4">
    <div v-for="query in props.currentRequest.queries" class="space-y-2">
      <div class="font-bold">{{ query.name }}</div>
      <div class="pl-5">
        <highlightjs language="sql" :code="query.sql" />
      </div>
      <div v-for="s in query.source" class="pl-5 text-stone-400 text-sm" v-text="s"></div>
    </div>
  </div>
</template>

<style scoped></style>
