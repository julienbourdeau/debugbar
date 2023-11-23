<script setup lang="ts">
import { computed, onMounted, ref } from "vue"
import TabButton from "@/components/TabButton.vue"
import ModelPanel from "@/components/panels/ModelPanel.vue"
import QueriesPanel from "@/components/panels/QueriesPanel.vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequest } from "@/models/Request.ts"

let requestsStore = useRequestsStore()

const active = ref("queries")
const currentRequest = ref({ models: {}, queries: [], id: "init", meta: {} } as unknown as BackendRequest)

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
      count: Object.values(currentRequest.value.models).reduce((a, b) => a + b, 0),
    },
    queries: {
      title: "Queries",
      count: currentRequest.value.queries.length || 0,
    },
    jobs: {
      title: "Jobs",
      count: 0, //currentRequest.value.jobs?.length || 0,
    },
  }
})
</script>

<template>
  <div class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200">
    <div class="flex">
      <tab-button
        v-for="(v, k) in summary"
        :name="k"
        :count="v.count"
        :active="active"
        @active-tab="active = $event.name"
      />
    </div>

    <div>
      <select
        class="px-2 py-1.5 bg-white border border-stone-200 rounded"
        name="current_request_id"
        @change="updateCurrentRequest($event.target)"
      >
        <option v-for="r in requestsStore.requests" v-text="[r.meta.method, r.meta.path].join(' ')" :value="r.id" />
      </select>
    </div>
  </div>

  <model-panel v-if="active == 'models'" :models="currentRequest?.models" />
  <queries-panel v-if="active == 'queries'" :current-request="currentRequest" />
</template>
