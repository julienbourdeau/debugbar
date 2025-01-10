<script setup lang="ts">
import { HttpCall } from "@/models/Request.ts"
import HttpRequestPanel from "@/components/panels/HttpRequestPanel.vue"
import HttpResponsePanel from "@/components/panels/HttpResponsePanel.vue"
import { ChevronDownIcon } from "@heroicons/vue/16/solid"
import { reactive } from "vue"
import HttpVerb from "@/components/ui/HttpVerb.vue"
import { extractAfterPath } from "@/helpers.ts"
import StatusCode from "@/components/ui/StatusCode.vue"

defineProps<{
  requests: HttpCall[]
}>()

const state = reactive({
  open: {},
})
</script>

<template>
  <div v-for="req in requests" :key="req.id">
    <h1
      class="flex items-center my-4 space-x-2 px-2 py-2.5 tracking-wide text-sm rounded cursor-pointer"
      @click="state.open[req.id] = !state.open[req.id]"
    >
      <chevron-down-icon
        class="size-4"
        :class="{
          '-rotate-90': !state.open[req.id],
        }"
      />
      <status-code :code="req.response?.status" />
      <http-verb :verb="req.request.method" />
      <span class="">
        <span class="text-black font-bold">{{ req.request.url.pathname }}</span>
        <span class="text-stone-600">{{ extractAfterPath(req.request.url) }}</span>
      </span>
    </h1>

    <div v-if="state.open[req.id]" class="lg:flex">
      <http-request-panel :request="req.request" class="lg:w-1/2 min-w-[450px]" />
      <http-response-panel :response="req.response" class="lg:w-1/2 min-w-[450px]" />
    </div>
  </div>
</template>
