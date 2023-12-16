<script setup lang="ts">
import type { Cache } from "@/models/Request.ts"

const props = defineProps<{
  cache: Cache[]
}>()
</script>

<template>
  {{ props.cache }}
</template>

<style scoped></style>
