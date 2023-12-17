<script setup lang="ts">
import { createConsumer } from "@rails/actioncable"
import { computed, onMounted, reactive, ref } from "vue"

import TabButton from "@/components/TabButton.vue"
import ModelsPanel from "@/components/panels/ModelsPanel.vue"
import QueriesPanel from "@/components/panels/QueriesPanel.vue"
import JobsPanel from "@/components/panels/JobsPanel.vue"
import DebugPanel from "@/components/panels/DebugPanel.vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { useConfigStore } from "@/stores/configStore.ts"
import MessagesPanel from "@/components/panels/MessagesPanel.vue"

let requestsStore = useRequestsStore()
let configStore = useConfigStore()

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

const consumer = createConsumer(configStore.config.actionCableUrl)
const debugbarChannel = consumer.subscriptions.create(
  { channel: configStore.config.options.channelName },
  {
    connected() {
      console.log("🟢 Connected to channel")
      debugbarChannel.send({ ids: [] })
    },

    disconnected() {
      console.log("🔴 Disconnected from channel")
    },
    received(data) {
      if (data.length == 0) {
        return
      }

      // console.log("Received: " + data.length + " request(s)")

      const ids = requestsStore.addRequests(data)

      if (!isActive.value) {
        requestsStore.setCurrentRequestById(ids[ids.length - 1])
      }

      setTimeout(() => {
        debugbarChannel.send({ ids: ids })
      }, 50)
    },
  }
)

const clearRequests = () => {
  console.log("Clearing requests")
  state.activeTab = ""
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

const setActiveTab = (tab) => {
  if (state.activeTab == tab) {
    state.activeTab = ""
  } else {
    state.activeTab = tab
  }
}
</script>

<template>
  <div v-if="state.minimized" @click="state.minimized = false" class="z-[9999] fixed left-0 bottom-0 shadow">
    <div class="flex items-center justify-between font-mono border-t-4 border-r-4 border-red-rails">
      <div class="p-1 pt-1.5">
        <img class="h-5" src="./assets/ruby-logo.svg" alt="Rails logo" />
      </div>
    </div>
  </div>

  <div v-if="!state.minimized && requestsStore.currentRequest == null" class="z-[9999] fixed left-0 bottom-0 w-full">
    <div class="h-1 bg-red-rails cursor-row-resize" />
    <div class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200">
      <div class="px-5">No request yet</div>
      <div><button v-if="!isActive" class="px-2 py-1.5" @click="state.minimized = true">Mini</button></div>
    </div>
  </div>

  <div v-if="!state.minimized && requestsStore.currentRequest" class="z-[9999] fixed left-0 bottom-0 w-full">
    <div id="drag" @mousedown="state.isResizing = true" class="h-1 bg-red-rails cursor-row-resize" />

    <div
      id="debubgbar-header"
      ref="header"
      class="flex items-center justify-between font-mono bg-stone-100 border-b-2 border-stone-300"
    >
      <!--  Left  -->
      <div>
        <div class="flex">
          <div class="p-1 pt-1.5">
            <img class="h-5" src="./assets/ruby-logo.svg" alt="Rails logo" />
          </div>

          <tab-button
            v-for="(v, k) in requestsStore.currentRequest.dataForTabs"
            key="k"
            :label="v.label"
            :count="v?.count"
            :is-active="k === state.activeTab"
            :disabled="v.disabled"
            @click="setActiveTab(k)"
            >{{ v.label }}</tab-button
          >

          <button
            @click="state.activeTab = 'debug'"
            class="flex items-center space-x-1 px-3 py-1.5 border-0 text-stone-500"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="text-current h-6 w-6"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none" />
              <path d="M3 12a9 9 0 1 0 18 0a9 9 0 0 0 -18 0" />
              <path d="M12 8v4" />
              <path d="M12 16h.01" />
            </svg>
          </button>
        </div>
      </div>

      <!--  Right  -->
      <div class="flex items-center space-x-2">
        <div class="flex space-x-1">
          <span class="text-sm font-black" v-if="requestsStore.currentRequest.meta.duration"
            >{{ requestsStore.currentRequest.meta.duration.toFixed(1) }}ms</span
          >
        </div>

        <select
          class="px-2 py-1.5 bg-white border border-stone-200 rounded w-[330px]"
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

        <div class="flex items-center space-x-2">
          <!--  Not ready yet -->
          <button
            v-if="requestsStore.currentRequest != null"
            class="border border-stone-300 shadow px-1.5"
            @click="clearRequests"
          >
            Clear
          </button>
          <button v-if="isActive" class="border border-stone-300 shadow px-1.5" @click="state.activeTab = ''">
            Close
          </button>
          <button v-if="!isActive" class="border border-stone-300 shadow px-1.5" @click="state.minimized = true">
            Mini
          </button>
        </div>
      </div>
    </div>

    <div
      ref="body"
      id="debugbar-body"
      class="bg-white overflow-scroll"
      v-if="state.activeTab != ''"
      :style="`height: ${state.height}px`"
    >
      <messages-panel
        v-if="state.activeTab == 'messages'"
        :messages="requestsStore.currentRequest?.messages"
        class="px-3 py-2"
      />
      <models-panel
        v-if="state.activeTab == 'models'"
        :models="requestsStore.currentRequest?.models"
        class="px-3 py-2"
      />
      <queries-panel
        v-if="state.activeTab == 'queries'"
        :current-request="requestsStore.currentRequest"
        class="px-3 py-2"
      />
      <jobs-panel v-if="state.activeTab == 'jobs'" :jobs="requestsStore.currentRequest?.jobs" class="px-3 py-2" />
      <debug-panel
        v-if="state.activeTab == 'debug'"
        :current-request="requestsStore.currentRequest"
        class="px-3 py-2"
      />
    </div>
  </div>
</template>
