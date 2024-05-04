<script setup lang="ts">
import { Message } from "@/models/Request.ts"
import { reactive } from "vue"
import PanelListItem from "@/components/panels/PanelListItem.vue"

defineProps<{
  msg: Message
}>()

const state = reactive({
  isFormatted: false,
})

function reformat(data: string) {
  return state.isFormatted ? JSON.stringify(data, null, 2) : JSON.stringify(data)
}
</script>

<template>
  <panel-list-item
    @toggle-formatting="state.isFormatted = !state.isFormatted"
    :title="msg.msg"
    :copyable-text="reformat(msg.extra)"
    :is-formatted="state.isFormatted"
    :source="msg.source"
  >
    <template v-slot:content>
      <highlightjs language="json" :code="reformat(msg.extra)" />
    </template>
  </panel-list-item>
</template>

<style scoped></style>
