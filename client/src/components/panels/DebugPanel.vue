<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  currentRequest: BackendRequest
}>()
</script>

<template>
  <div class="p-4">
    <h2>Debug</h2>

    <highlightjs language="json" :code="JSON.stringify(props.currentRequest, null, 2)" />
  </div>
</template>

<style scoped></style>
