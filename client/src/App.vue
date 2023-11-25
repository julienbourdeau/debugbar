<script setup lang="ts">
import { computed, onMounted, reactive, ref } from "vue"
import { createConsumer } from "@rails/actioncable"

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

  const consumer = createConsumer("ws://127.0.0.1:3000/_debugbar/cable")
  const debugbarChannel = consumer.subscriptions.create(
    { channel: "DebugbarRb::DebugbarChannel" },
    {
      received(data) {
        console.log("Received: ", data)
        if (data.length == 0) {
          return
        }

        const ids = requestsStore.addRequests(data)
        currentRequest.value = requestsStore.getCurrentRequest()

        setTimeout(() => {
          debugbarChannel.send({ ids: ids })
        }, 50)
      },
    }
  )
  setTimeout(() => {
    debugbarChannel.send({ ids: [] })
  }, 100)

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
      label: "Models",
      count: currentRequest.value.modelsCount,
    },
    queries: {
      label: "Queries",
      count: currentRequest.value.queryCount,
    },
    jobs: {
      label: "Jobs",
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
    <div id="drag" @mousedown="state.isResizing = true" class="h-1 bg-red-rails cursor-row-resize"></div>

    <div
      id="debubgbar-header"
      ref="header"
      class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200"
    >
      <!--  Left  -->
      <div>
        <div class="flex">
          <div class="p-1 pt-1.5">
            <img class="h-5" src="./assets/ruby-logo.svg" alt="Rails logo" />
          </div>

          <tab-button
            v-for="(v, k) in summary"
            key="k"
            :label="v.label"
            :count="v.count"
            :is-active="k === state.active"
            @click="state.active = k"
          />
        </div>
      </div>

      <!--  Right  -->
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
      <model-panel v-if="state.active == 'models'" :models="currentRequest?.models" class="px-3 py-2" />
      <queries-panel v-if="state.active == 'queries'" :current-request="currentRequest" class="px-3 py-2" />
    </div>
  </div>
</template>
