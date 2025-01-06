<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"
import JsonCode from "@/components/ui/JsonCode.vue"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="p-4 leading-8">
    <json-code :json="request" />
  </div>
</template>

<style scoped></style>
