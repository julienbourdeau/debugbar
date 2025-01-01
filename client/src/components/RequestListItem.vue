<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div>{{ props.request.pathWithVerb }}</div>
</template>
