<script setup lang="ts">
import { Message } from "@/models/Request.ts"

const props = defineProps<{
  messages: Message[]
}>()
</script>

<template>
  <div class="flex flex-col space-y-8">
    <!--    <div v-for="(msg, idx) in props.messages" v-text="msg.msg"></div>-->
    <div v-for="(msg, _idx) in props.messages" class="space-y-3">
      <div class="font-bold text-lg" v-text="msg.msg"></div>
      <div class="ml-4">
        <div v-if="!msg.extra">–</div>
        <highlightjs v-if="msg.extra" language="json" :code="JSON.stringify(msg.extra)" />
      </div>
    </div>
  </div>
</template>

<style scoped></style>
