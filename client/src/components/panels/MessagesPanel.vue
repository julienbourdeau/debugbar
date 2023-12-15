<script setup lang="ts">
import { Message } from "@/models/Request.ts"

const props = defineProps<{
  messages: Message[]
}>()
</script>

<template>
  {{ props }}
</template>

<style scoped></style>
