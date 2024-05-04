<script setup lang="ts">
import { Message } from "@/models/Request.ts"
import Panel from "@/components/panels/Panel.vue"
import MessageItem from "@/components/messages/MessageItem.vue"

const props = defineProps<{
  messages: Message[]
}>()
</script>

<template>
  <panel>
    <div class="flex flex-col space-y-8">
      <div v-for="msg in props.messages" :key="msg.id" class="space-y-3">
        <message-item :msg="msg" />
      </div>
    </div>
  </panel>
</template>

<style scoped></style>
