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
  idOpen: "",
})
</script>

<template>
  <div v-for="req in requests" :key="req.id">
    <h1
      class="flex items-center my-4 mx-2 space-x-2 px-2 py-2.5 bg-stone-100 border border-stone-300 tracking-wide text-sm rounded cursor-pointer"
      @click="state.idOpen = state.idOpen === req.id ? '' : req.id"
    >
      <chevron-down-icon
        class="size-4"
        :class="{
          '-rotate-90': state.idOpen !== req.id,
        }"
      />
      <status-code :code="req.response?.status" />
      <http-verb :verb="req.request.method" />
      <span class="">
        <span class="text-black font-bold">{{ req.request.url.pathname }}</span>
        <span class="text-stone-600">{{ extractAfterPath(req.request.url) }}</span>
      </span>
    </h1>

    <div v-if="state.idOpen == req.id" class="flex">
      <http-request-panel :request="req.request" class="w-1/2" />
      <http-response-panel :response="req.response" class="w-1/2" />
    </div>
  </div>
</template>
