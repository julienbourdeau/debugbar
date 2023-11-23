<script setup lang="ts">
import { computed, onMounted, reactive, ref } from "vue"
import TabButton from "@/components/TabButton.vue"
import ModelPanel from "@/components/panels/ModelPanel.vue"
import QueriesPanel from "@/components/panels/QueriesPanel.vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequest, BackendRequestData } from "@/models/Request.ts"

let requestsStore = useRequestsStore()

const header = ref(null)

const state = reactive({
  active: "",
  isResizing: false,
  height: 300,
})

const currentRequest = ref(new BackendRequest({} as unknown as BackendRequestData))

function updateCurrentRequest(target) {
  requestsStore.setCurrentRequestId(target.value)
  currentRequest.value = requestsStore.getCurrentRequest()
}

onMounted(() => {
  currentRequest.value = requestsStore.getCurrentRequest()

  document.onmousemove = function (e) {
    if (!state.isResizing) {
      return
    }

    state.height = window.innerHeight - e.clientY - header.value.clientHeight
  }

  document.onmouseup = function (_e) {
    state.isResizing = false
  }
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
      id="drag"
      @mousedown="state.isResizing = true"
      @mouseup="state.isResizing = false"
      class="h-1 bg-red-300 cursor-row-resize"
    ></div>

    <div
      id="debubgbar-header"
      ref="header"
      class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200"
    >
      <div class="flex">
        <tab-button
          v-for="(v, k) in summary"
          :name="k"
          :count="v.count"
          :active="state.active"
          @active-tab="state.active = $event.name"
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

        <button class="px-2 py-1.5" @click="state.active = ''">Close</button>
      </div>
    </div>

    <div
      ref="body"
      id="debugbar-body"
      class="bg-white overflow-scroll"
      v-if="state.active != ''"
      :style="`height: ${state.height}px`"
    >
      <model-panel v-if="state.active == 'models'" :models="currentRequest?.models" />
      <queries-panel v-if="state.active == 'queries'" :current-request="currentRequest" />
    </div>
  </div>
</template>
