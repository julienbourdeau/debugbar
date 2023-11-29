<script setup lang="ts">
import { computed, onMounted, reactive, ref } from "vue"
import { createConsumer } from "@rails/actioncable"

import TabButton from "@/components/TabButton.vue"
import ModelPanel from "@/components/panels/ModelPanel.vue"
import QueriesPanel from "@/components/panels/QueriesPanel.vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"

let requestsStore = useRequestsStore()

const header = ref(null)

const state = reactive({
  activeTab: "",
  minimized: false,
  isResizing: false,
  height: 300,
})

const isActive = computed(() => {
  return state.activeTab != ""
})

const consumer = createConsumer("ws://127.0.0.1:3000/_debugbar/cable")
const debugbarChannel = consumer.subscriptions.create(
  { channel: "DebugbarRb::DebugbarChannel" },
  {
    connected() {
      console.log("Connected to channel, sending initial request")
      debugbarChannel.send({ ids: [] })
    },

    disconnected() {
      console.log("disconnected from channel ")
    },
    received(data) {
      console.log("Received: ", data)

      if (data.length == 0) {
        console.log("No data received")
        return
      }

      const ids = requestsStore.addRequests(data)

      if (!isActive.value) {
        console.log("Setting current request")
        requestsStore.setCurrentRequestById(ids[ids.length - 1])
      }

      setTimeout(() => {
        console.log("Sending ids", ids)
        debugbarChannel.send({ ids: ids })
      }, 50)
    },
  }
)

const clearRequests = () => {
  console.log("Clearing requests")
  requestsStore.clearRequests()
  debugbarChannel.send({ clear: true })
}

// Resizing the debugbar
onMounted(() => {
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
</script>

<template>
  <div
    v-if="state.minimized"
    @click="state.minimized = false"
    class="bug-z-[9999] bug-fixed bug-left-0 bug-bottom-0 bug-shadow"
  >
    <div
      class="bug-flex bug-items-center bug-justify-between bug-font-mono bug-border-t-4 bug-border-r-4 bug-border-red-rails"
    >
      <div class="bug-p-1 bug-pt-1.5">
        <img class="bug-h-5" src="./assets/ruby-logo.svg" alt="Rails logo" />
      </div>
    </div>
  </div>

  <div
    v-if="!state.minimized && requestsStore.currentRequest == null"
    class="bug-z-[9999] bug-fixed bug-left-0 bug-bottom-0 bug-w-full"
  >
    <div class="bug-h-1 bug-bg-red-rails bug-cursor-row-resize" />
    <div
      class="bug-flex bug-items-center bug-justify-between bug-font-mono bug-bg-stone-100 bug-border-b bug-border-stone-200"
    >
      <div class="bug-px-5">No request yet</div>
      <div><button v-if="!isActive" class="bug-px-2 bug-py-1.5" @click="state.minimized = true">Mini</button></div>
    </div>
  </div>

  <div
    v-if="!state.minimized && requestsStore.currentRequest"
    class="bug-z-[9999] bug-fixed bug-left-0 bug-bottom-0 bug-w-full"
  >
    <div id="drag" @mousedown="state.isResizing = true" class="bug-h-1 bug-bg-red-rails bug-cursor-row-resize" />

    <div
      id="debubgbar-header"
      ref="header"
      class="bug-flex bug-items-center bug-justify-between bug-font-mono bug-bg-stone-100 bug-border-b bug-border-stone-200"
    >
      <!--  Left  -->
      <div>
        <div class="bug-flex">
          <div class="bug-p-1 bug-pt-1.5">
            <img class="bug-h-5" src="./assets/ruby-logo.svg" alt="Rails logo" />
          </div>

          <tab-button
            v-for="(v, k) in requestsStore.currentRequest.dataForTabs"
            key="k"
            :label="v.label"
            :count="v.count"
            :is-active="k === state.activeTab"
            @click="state.activeTab = k as string"
          />
        </div>
      </div>

      <!--  Right  -->
      <div class="bug-flex bug-items-center bug-space-x-2">
        <div class="bug-flex bug-space-x-1">
          <span class="bug-text-sm bug-font-black" v-if="requestsStore.currentRequest.meta.duration"
            >{{ requestsStore.currentRequest.meta.duration.toFixed(1) }}ms</span
          >
        </div>

        <select
          class="bug-px-2 bug-py-1.5 bug-bg-white bug-border bug-border-stone-200 bug-rounded bug-max-w-[300px]"
          name="current_request_id"
          @change="
            (event) => {
              const target = event.target as HTMLSelectElement
              requestsStore.setCurrentRequestById(target.value)
            }
          "
        >
          <option
            v-for="r in requestsStore.requests"
            :selected="requestsStore.currentRequest.id == r.id"
            v-text="r.pathWithVerb"
            :value="r.id"
          />
        </select>

        <button v-if="requestsStore.currentRequest != null" class="bug-px-2 bug-py-1.5" @click="clearRequests">
          Clear
        </button>
        <button v-if="isActive" class="bug-px-2 bug-py-1.5" @click="state.activeTab = ''">Close</button>
        <button v-if="!isActive" class="bug-px-2 bug-py-1.5" @click="state.minimized = true">Mini</button>
      </div>
    </div>

    <div
      ref="body"
      id="debugbar-body"
      class="bug-bg-white bug-overflow-scroll"
      v-if="state.activeTab != ''"
      :style="`height: ${state.height}px`"
    >
      <model-panel
        v-if="state.activeTab == 'models'"
        :models="requestsStore.currentRequest?.models"
        class="bug-px-3 bug-py-2"
      />
      <queries-panel
        v-if="state.activeTab == 'queries'"
        :current-request="requestsStore.currentRequest"
        class="bug-px-3 bug-py-2"
      />
    </div>
  </div>
</template>
