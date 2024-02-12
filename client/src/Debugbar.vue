<script setup lang="ts">
import { createConsumer } from "@rails/actioncable"
import { computed, onMounted, reactive, ref } from "vue"
import { CodeBracketIcon, XCircleIcon, ArrowDownLeftIcon, TrashIcon } from "@heroicons/vue/16/solid"

import TabButton from "@/components/TabButton.vue"
import ModelsPanel from "@/components/panels/ModelsPanel.vue"
import QueriesPanel from "@/components/queries/QueriesPanel.vue"
import JobsPanel from "@/components/panels/JobsPanel.vue"
import LogsPanel from "@/components/panels/LogsPanel.vue"
import MessagesPanel from "@/components/panels/MessagesPanel.vue"

import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { useConfigStore } from "@/stores/configStore.ts"
import CachePanel from "@/components/panels/CachePanel.vue"
import RequestPanel from "@/components/panels/RequestPanel.vue"
import JsonPanel from "@/components/panels/JsonPanel.vue"
import LogoRuby from "@/components/ui/logo-ruby.vue"

let requestsStore = useRequestsStore()
let configStore = useConfigStore()

const header = ref(null)

const state = reactive({
  activeTab: "",
  minimized: false,
  isResizing: false,
  height: configStore.config.height,
})

const isActive = computed(() => {
  return state.activeTab != ""
})

const devMode = computed(() => {
  return import.meta.env.DEV
})

const routeAlias = computed(() => {
  return requestsStore.currentRequest?.meta.params.controller + "#" + requestsStore.currentRequest?.meta.params.action
})

let debugbarChannel

if (configStore.config.mode == "ws") {
  debugbarChannel = createConsumer(configStore.config.actionCableUrl).subscriptions.create(
    { channel: configStore.config.channelName },
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
} else {
  console.log(`Using debugbar in "offline mode", ideal for demoing with fixtures.`)
  debugbarChannel = {
    send: (data) => {
      // No-op
      console.log("Ignoring `send` call", data)
    },
  }
}

const clearRequests = () => {
  console.log("Clearing requests")
  state.activeTab = ""
  requestsStore.clearRequests()
  debugbarChannel.send({ clear: true })
}

// Resizing the debugbar
onMounted(() => {
  window.onresize = function () {
    if (window.innerHeight < state.height) {
      state.height = window.innerHeight - header.value.clientHeight
    }
  }

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
    state.activeTab = "" // Close if you click on active tab
  } else {
    if (window.innerHeight < state.height) {
      state.height = window.innerHeight - header.value.clientHeight * 2
    }
    state.activeTab = tab
  }
}
</script>

<template>
  <div
    v-if="state.minimized"
    @click="state.minimized = false"
    class="z-[9999] fixed left-0 bottom-0 bg-transparent cursor-pointer"
  >
    <div class="p-1 pt-1.5">
      <img class="h-5" src="./assets/ruby-logo.svg" alt="Logo" />
    </div>
  </div>

  <div v-if="!state.minimized && requestsStore.currentRequest == null" class="z-[9999] fixed left-0 bottom-0 w-full">
    <div class="h-0.5 bg-red-700 cursor-row-resize" />
    <div class="flex items-center justify-between bg-stone-100 border-b border-stone-200">
      <div class="px-5 py-1.5 italic">No request yet</div>
      <div class="px-3">
        <button @click="state.minimized = true" title="Hide in the corner">
          <arrow-down-left-icon class="size-4" />
        </button>
      </div>
    </div>
  </div>

  <div v-if="!state.minimized && requestsStore.currentRequest" class="z-[9999] fixed left-0 bottom-0 w-full">
    <div id="draggable-bar" @mousedown="state.isResizing = true" class="h-0.5 bg-red-700 cursor-row-resize" />

    <div
      id="debubgbar-header"
      ref="header"
      class="flex px-1 items-center justify-between bg-stone-100 border-b-2 border-stone-300"
    >
      <!--  Left  -->
      <div>
        <div class="flex">
          <div class="p-1 pt-1.5">
            <logo-ruby />
          </div>

          <tab-button
            v-for="(v, k) in requestsStore.currentRequest.dataForTabs"
            key="k"
            :label="v.label"
            :count="v?.count"
            :is-active="k === state.activeTab"
            :disabled="v.count == 0"
            @click="setActiveTab(k)"
            >{{ v.label }}</tab-button
          >

          <button
            v-if="devMode"
            @click="setActiveTab('debug')"
            class="px-3 py-1.5 text-stone-600"
            :class="{ 'bg-stone-300': state.activeTab == 'debug' }"
          >
            <CodeBracketIcon class="size-4" />
          </button>
        </div>
      </div>

      <!--  Right  -->
      <div class="flex items-center space-x-2.5 pr-1">
        <div @click="setActiveTab('request')" class="flex space-x-2 cursor-pointer">
          <span class="text-sm text-stone-600 font-medium tracking-wide">
            {{ routeAlias }}
          </span>

          <span
            class="text-sm font-bold"
            v-if="requestsStore.currentRequest.meta.duration < 1000"
            :class="{
              'text-orange-600': requestsStore.currentRequest.meta.duration >= 800,
            }"
            >{{ requestsStore.currentRequest.meta.duration.toFixed(1) }}ms</span
          >
          <span
            class="text-sm font-bold text-red-600 bg-red-100 px-1 rounded"
            v-if="requestsStore.currentRequest.meta.duration >= 1000"
            >{{ (requestsStore.currentRequest.meta.duration / 1000).toFixed(2) }}s</span
          >

          <span
            class="px-1 py-0.5 rounded text-xs"
            :class="{
              'bg-green-600 text-white': requestsStore.currentRequest.meta.status < 300,
              'bg-amber-600 text-white':
                requestsStore.currentRequest.meta.status >= 400 && requestsStore.currentRequest.meta.status < 500,
              'bg-red-600 text-white': requestsStore.currentRequest.meta.status >= 500,
            }"
            >{{ requestsStore.currentRequest.meta.status }}</span
          >
        </div>

        <select
          class="px-2 py-1.5 bg-white border border-stone-200 rounded w-[330px] text-sm"
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

        <button @click="clearRequests" title="Clear all requests (frontend and backend)">
          <trash-icon class="size-4" />
        </button>

        <div class="flex items-center pl-2 space-x-2">
          <button @click="state.minimized = true" title="Hide in the corner">
            <arrow-down-left-icon class="size-4" />
          </button>
          <button :disabled="!isActive" @click="state.activeTab = ''" title="Close">
            <x-circle-icon class="size-4" />
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
      <request-panel v-if="state.activeTab == 'request'" :request="requestsStore.currentRequest" />
      <messages-panel v-if="state.activeTab == 'messages'" :messages="requestsStore.currentRequest?.messages" />
      <models-panel
        v-if="state.activeTab == 'models'"
        :models="requestsStore.currentRequest?.models"
        :count="requestsStore.currentRequest?.modelsCount"
      />
      <queries-panel v-if="state.activeTab == 'queries'" :current-request="requestsStore.currentRequest" />
      <jobs-panel v-if="state.activeTab == 'jobs'" :jobs="requestsStore.currentRequest?.jobs" />
      <cache-panel v-if="state.activeTab == 'cache'" :cache="requestsStore.currentRequest?.cache" />
      <logs-panel v-if="state.activeTab == 'logs'" :logs="requestsStore.currentRequest?.logs" />
      <json-panel
        v-if="devMode && state.activeTab == 'debug'"
        :current-request="requestsStore.currentRequest"
        class="px-3 py-2"
      />
    </div>
  </div>
</template>
