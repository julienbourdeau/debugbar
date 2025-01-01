<script setup lang="ts">
import HttpVerb from "@/components/HttpVerb.vue"
import { BackendRequest } from "@/models/Request.ts"

const p = defineProps({
  r: BackendRequest,
})
</script>

<template>
  <div class="flex item-center space-x-2 py-2 border-0">
    <http-verb :verb="p.r.meta.method" />
    <span>{{ p.r.meta.path }}</span>
  </div>
</template>

<style scoped></style>
