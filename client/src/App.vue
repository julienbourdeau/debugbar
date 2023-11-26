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

// Websocket connection
onMounted(() => {
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

        if (!isActive.value) {
          requestsStore.setCurrentRequestById(ids[ids.length - 1])
        }

        setTimeout(() => {
          debugbarChannel.send({ ids: ids })
        }, 10)
      },
    }
  )

  setTimeout(() => {
    debugbarChannel.send({ ids: [] })
  }, 100)
})

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
  <div v-if="state.minimized" @click="state.minimized = false" class="fixed left-0 bottom-0 shadow">
    <!--    <div class="h-1 bg-red-rails cursor-row-resize" />-->
    <div class="flex items-center justify-between font-mono border-t-4 border-r-4 border-red-rails">
      <div class="p-1 pt-1.5">
        <img class="h-5" src="./assets/ruby-logo.svg" alt="Rails logo" />
      </div>
    </div>
  </div>

  <div v-if="!state.minimized && requestsStore.currentRequest == null" class="fixed left-0 bottom-0 w-full">
    <div class="h-1 bg-red-rails cursor-row-resize" />
    <div class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200">
      <div class="px-5">No request yet</div>
      <div><button v-if="!isActive" class="px-2 py-1.5" @click="state.minimized = true">Mini</button></div>
    </div>
  </div>

  <div v-if="!state.minimized && requestsStore.currentRequest" class="fixed left-0 bottom-0 w-full">
    <div id="drag" @mousedown="state.isResizing = true" class="h-1 bg-red-rails cursor-row-resize" />

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
            v-for="(v, k) in requestsStore.currentRequest.dataForTabs"
            key="k"
            :label="v.label"
            :count="v.count"
            :is-active="k === state.activeTab"
            @click="state.activeTab = k"
          />
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
          class="px-2 py-1.5 bg-white border border-stone-200 rounded"
          name="current_request_id"
          @change="requestsStore.setCurrentRequestById($event.target.value)"
        >
          <option
            v-for="r in requestsStore.requests"
            :selected="requestsStore.currentRequest.id == r.id"
            v-text="r.pathWithVerb"
            :value="r.id"
          />
        </select>

        <button v-if="isActive" class="px-2 py-1.5" @click="state.activeTab = ''">Close</button>
        <button v-if="!isActive" class="px-2 py-1.5" @click="state.minimized = true">Mini</button>
      </div>
    </div>

    <div
      ref="body"
      id="debugbar-body"
      class="bg-white overflow-scroll"
      v-if="state.activeTab != ''"
      :style="`height: ${state.height}px`"
    >
      <model-panel
        v-if="state.activeTab == 'models'"
        :models="requestsStore.currentRequest?.models"
        class="px-3 py-2"
      />
      <queries-panel
        v-if="state.activeTab == 'queries'"
        :current-request="requestsStore.currentRequest"
        class="px-3 py-2"
      />
    </div>
  </div>
</template>
