<script setup lang="ts">
import Panel from "@/components/panels/Panel.vue"
import { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <panel> {{ JSON.stringify(props.request.meta, null, 2) }} </panel>
</template>
