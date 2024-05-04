<script setup lang="ts">
import { Message } from "@/models/Request.ts"
import Panel from "@/components/panels/Panel.vue"
import { reactive } from "vue"
import { copyToClipboard } from "@/helpers.ts"

defineProps<{
  msg: Message
}>()

const state = reactive({
  isOpen: true,
  isFormatted: false,
  showOriginFile: false,
})

function format(data: string) {
  return state.isFormatted ? JSON.stringify(data, null, 2) : JSON.stringify(data)
}
</script>

<template>
  <panel>
    <div class="flex items-center space-x-4">
      <div @click="state.isOpen = !state.isOpen" class="font-bold text-lg" v-text="msg.msg"></div>

      <div v-if="state.isOpen">
        <span
          @click="state.isFormatted = !state.isFormatted"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Format SQL query"
          v-text="state.isFormatted ? 'unformat' : 'format'"
        />
        <span
          v-if="msg.extra"
          @click="copyToClipboard(JSON.stringify(msg.extra))"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Copy SQL query to clipboard"
          >copy</span
        >
        <span
          @click="state.showOriginFile = !state.showOriginFile"
          class="px-3 text-xs uppercase text-stone-400 cursor-pointer"
          title="Show origin file of the query"
          >file</span
        >
      </div>
    </div>

    <div v-if="state.isOpen && msg.extra">
      <highlightjs language="json" :code="format(msg.extra)" />

      <div v-if="state.showOriginFile" class="mt-3 text-stone-400 text-sm">
        <div v-text="msg.source[0]"></div>
        <div v-if="msg.source.length > 1" v-for="s in msg.source.slice(1)" class="pl-4" v-text="'↳ ' + s"></div>
      </div>
    </div>
  </panel>
</template>

<style scoped></style>
