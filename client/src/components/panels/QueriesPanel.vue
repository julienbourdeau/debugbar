<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  currentRequest: BackendRequest
}>()
</script>

<template>
  <div class="flex flex-col space-y-8">
    <div v-for="query in props.currentRequest.queries" class="space-y-3">
      <div class="font-bold">{{ query.name }}</div>
      <div class="">
        <highlightjs language="sql" :code="query.sql" />
      </div>
      <div class="text-stone-400 text-sm">
        <div v-text="query.source[0]"></div>
        <div v-if="query.source.length > 1" v-for="s in query.source.slice(1)" class="pl-4" v-text="'↳ ' + s"></div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
