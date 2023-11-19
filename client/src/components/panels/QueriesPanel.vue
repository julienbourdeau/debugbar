<script setup lang="ts">
import {useRequestsStore} from "../../stores/RequestsStore.ts";

let requestsStore = useRequestsStore()
</script>

<template>
  <div class="flex flex-col space-y-4">
    <div v-for="query in requestsStore.requests[0].queries" class="space-y-1.5">
      <div class="font-bold">{{ query.name }}</div>
      <div class="pl-5">{{ query.sql }}</div>
      <div v-for="s in query.source" class="pl-5 text-stone-400 text-sm" v-text="s"></div>
    </div>
  </div>
</template>

<style scoped>

</style>
