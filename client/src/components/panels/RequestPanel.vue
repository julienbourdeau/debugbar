<script setup lang="ts">
import Panel from "@/components/panels/Panel.vue"
import { BackendRequest } from "@/models/Request.ts"
import KeyValueTable from "@/components/ui/KeyValueTable.vue"
import Row from "@/components/ui/Row.vue"
import SubHeading from "@/components/ui/SubHeading.vue"
import HttpResponsePanel from "@/components/panels/HttpResponsePanel.vue"
import HttpRequestPanel from "@/components/panels/HttpRequestPanel.vue"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="flex">
    <div class="w-1/2">
      <http-request-panel :request="request.request" />
    </div>

    <div class="w-1/2">
      <panel>
        <sub-heading>Routing</sub-heading>

        <key-value-table>
          <row title="Controller"> {{ request.meta.controller }} > {{ request.meta.action }} </row>
        </key-value-table>
      </panel>

      <http-response-panel v-if="request.response?.status" :response="request.response" />

      <div v-if="!request.response?.status">
        <div class="py-3 text-sm text-stone-500">
          The response was not captured.
          <a target="_blank" class="underline font-bold" href="https://debugbar.dev/docs/known-limitations/"
            >Learn more</a
          >
        </div>
      </div>
    </div>
  </div>

  <div class="w-full">
    <div class="py-3 text-center italic text-sm text-stone-500">
      What else would like to see here?
      <a target="_blank" class="underline font-bold" href="https://github.com/julienbourdeau/debugbar/discussions"
        >Tell me!</a
      >
    </div>
  </div>
</template>
