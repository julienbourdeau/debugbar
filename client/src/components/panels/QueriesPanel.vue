<script setup lang="ts">
import type { BackendRequest } from "@/models/Request.ts"

const props = defineProps<{
  currentRequest: BackendRequest
}>()

function copyToClipboard(text: string) {
  const type = "text/plain"
  const blob = new Blob([text], { type })
  const data = [new ClipboardItem({ [type]: blob })]
  navigator.clipboard.write(data)
}
</script>

<template>
  <div class="flex flex-col space-y-8">
    <div v-for="query in props.currentRequest.queries" class="space-y-3">
      <div class="font-bold">
        {{ query.name }}
        <span
          @click="copyToClipboard(query.sql)"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Copy SQL query to clipboard"
          >copy</span
        >
      </div>
      <div class="">
        <highlightjs language="sql" :code="query.sql" />
      </div>
      <div class="text-stone-400 text-sm">
        <div v-text="query.source[0]"></div>
        <div v-if="query.source.length > 1" v-for="s in query.source.slice(1)" class="pl-4" v-text="'↳ ' + s"></div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
