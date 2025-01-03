<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="p-4 leading-8">
    <highlightjs language="json" :code="JSON.stringify(request, null, 2)" />
  </div>
</template>

<style scoped></style>
