<script setup lang="ts">
defineProps<{
  json: object
}>()
</script>

<template>
  <highlightjs class="text-sm" language="json" :code="JSON.stringify(json, null, 2)" />
</template>
