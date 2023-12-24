<script setup lang="ts">
import { Message } from "@/models/Request.ts"
import Panel from "@/components/panels/Panel.vue"

const props = defineProps<{
  messages: Message[]
}>()
</script>

<template>
  <panel>
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
  </panel>
</template>

<style scoped></style>
