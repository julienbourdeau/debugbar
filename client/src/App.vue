<script setup lang="ts">
import { computed, onMounted, ref } from "vue"
import TabButton from "@/components/TabButton.vue"
import ModelPanel from "@/components/panels/ModelPanel.vue"
import QueriesPanel from "@/components/panels/QueriesPanel.vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequest, BackendRequestData } from "@/models/Request.ts"

let requestsStore = useRequestsStore()

const active = ref("")
const currentRequest = ref(new BackendRequest({} as unknown as BackendRequestData))

function updateCurrentRequest(target) {
  requestsStore.setCurrentRequestId(target.value)
  currentRequest.value = requestsStore.getCurrentRequest()
}

onMounted(() => {
  currentRequest.value = requestsStore.getCurrentRequest()
})

const summary = computed(() => {
  return {
    models: {
      title: "Models",
      count: currentRequest.value.modelsCount,
    },
    queries: {
      title: "Queries",
      count: currentRequest.value.queryCount,
    },
    jobs: {
      title: "Jobs",
      count: 0,
    },
  }
})
</script>

<template>
  <div
    :class="{
      'fixed left-0 bottom-0 w-full': true,
    }"
  >
    <div
      id="debubgbar-header"
      class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200"
    >
      <div class="flex">
        <tab-button
          v-for="(v, k) in summary"
          :name="k"
          :count="v.count"
          :active="active"
          @active-tab="active = $event.name"
        />
      </div>

      <div class="flex items-center space-x-2">
        <div class="flex space-x-1">
          <span class="text-sm font-black" v-if="currentRequest.meta.duration"
            >{{ currentRequest.meta.duration.toFixed(1) }}ms</span
          >
        </div>

        <select
          class="px-2 py-1.5 bg-white border border-stone-200 rounded"
          name="current_request_id"
          @change="updateCurrentRequest($event.target)"
        >
          <option v-for="r in requestsStore.requests" v-text="r.pathWithVerb" :value="r.id" />
        </select>

        <button class="px-2 py-1.5" @click="active = ''">Close</button>
      </div>
    </div>

    <div id="debugbar-body" class="bg-white overflow-scroll" v-if="active != ''" style="height: 300px">
      <model-panel v-if="active == 'models'" :models="currentRequest?.models" />
      <queries-panel v-if="active == 'queries'" :current-request="currentRequest" />
    </div>
  </div>
</template>
