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
      class="bug-flex bug-items-center bug-justify-between bug-font-mono bug-bg-stone-100 bug-border-b-2 bug-border-stone-300"
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
            :count="v?.count"
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
          class="bug-px-2 bug-py-1.5 bug-bg-white bug-border bug-border-stone-200 bug-rounded bug-w-[330px]"
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

        <div class="bug-flex bug-items-center bug-space-x-2">
          <!--  Not ready yet -->
          <button
            v-if="false && requestsStore.currentRequest != null"
            class="bug-border bug-border-stone-300 bug-shadow bug-px-1.5"
            @click="clearRequests"
          >
            Clear
          </button>
          <button
            v-if="isActive"
            class="bug-border bug-border-stone-300 bug-shadow bug-px-1.5"
            @click="state.activeTab = ''"
          >
            Close
          </button>
          <button
            v-if="!isActive"
            class="bug-border bug-border-stone-300 bug-shadow bug-px-1.5"
            @click="state.minimized = true"
          >
            Mini
          </button>
        </div>
      </div>
    </div>

    <div
      ref="body"
      id="debugbar-body"
      class="bug-bg-white bug-overflow-scroll"
      v-if="state.activeTab != ''"
      :style="`height: ${state.height}px`"
    >
      <models-panel
        v-if="state.activeTab == 'models'"
        :models="requestsStore.currentRequest?.models"
        class="bug-px-3 bug-py-2"
      />
      <queries-panel
        v-if="state.activeTab == 'queries'"
        :current-request="requestsStore.currentRequest"
        class="bug-px-3 bug-py-2"
      />
      <jobs-panel
        v-if="state.activeTab == 'jobs'"
        :jobs="requestsStore.currentRequest?.jobs"
        class="bug-px-3 bug-py-2"
      />
      <debug-panel
        v-if="state.activeTab == 'debug'"
        :current-request="requestsStore.currentRequest"
        class="bug-px-3 bug-py-2"
      />
    </div>
  </div>
</template>
