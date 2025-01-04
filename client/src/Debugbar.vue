<!-- This is the main component of the debugbar. -->
<!--It's imported in the different App*.vue components.-->

<script setup lang="ts">
import { createConsumer } from "@rails/actioncable"
import { computed, onMounted, reactive, ref } from "vue"
import {
  CodeBracketIcon,
  XCircleIcon,
  ArrowDownLeftIcon,
  TrashIcon,
  PauseIcon,
  PlayIcon,
} from "@heroicons/vue/16/solid"

import TabButton from "@/components/TabButton.vue"

import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { useConfigStore } from "@/stores/configStore.ts"
import RubyLogo from "@/components/ui/RubyLogo.vue"
import StatusCode from "@/components/ui/StatusCode.vue"
import DebugbarBody from "@/DebugbarBody.vue"
import RequestTimings from "@/components/RequestTimings.vue"

let requestsStore = useRequestsStore()
let configStore = useConfigStore()

const header = ref(null)

const state = reactive({
  activeTab: "",
  minimized: configStore.config.minimized,
  isResizing: false,
  isPolling: configStore.config.mode === "poll",
  height: configStore.config.height,
})

const isOpen = computed(() => {
  return state.activeTab != ""
})

const devMode = computed(() => {
  return import.meta.env.DEV
})

let debugbarChannel = null

const setupPollingMode = () => {
  console.log(
    `Using debugbar in "polling mode". Consider using "ws" mode for better performance (requires ActionCable).`
  )
  setInterval(() => {
    if (!state.isPolling) {
      return
    }

    fetch(configStore.config.pollUrl)
      .then((response) => response.json())
      .then((data) => {
        if (data.length == 0) {
          return
        }

        console.log(data)

        const ids = requestsStore.addRequests(data)

        if (!isOpen.value) {
          requestsStore.setCurrentRequestById(ids[ids.length - 1])
        }

        fetch(configStore.config.pollUrl + "/confirm", {
          // mode: "no-cors",
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ ids: ids }),
        })
      })
  }, configStore.config.poll.interval)
}

if (configStore.config.mode === "ws") {
  debugbarChannel = createConsumer(configStore.config.actionCableUrl).subscriptions.create(
    { channel: configStore.config.cable.channelName },
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

        if (!isOpen.value) {
          requestsStore.setCurrentRequestById(ids[ids.length - 1])
        }

        setTimeout(() => {
          debugbarChannel.send({ ids: ids })
        }, 50)
      },
    }
  )
} else if (configStore.config.mode === "poll") {
  setupPollingMode()
} else {
  console.log(`Using debugbar in "offline mode", ideal for demos using fixtures.`)
}

const clearRequests = () => {
  console.log("Clearing requests")
  state.activeTab = ""
  requestsStore.clearRequests()
  debugbarChannel?.send({ clear: true })
  state.isPolling = true
}

const togglePolling = () => {
  state.isPolling = !state.isPolling
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
  if (window.innerHeight < state.height) {
    state.height = window.innerHeight - header.value.clientHeight * 2
  }
  state.activeTab = tab
}
</script>

<template>
  <!--  Minimized bar, just a clickable ruby logo in the bottom left corner -->
  <div
    v-if="state.minimized"
    @click="state.minimized = false"
    class="z-[9999] text-stone-900 fixed left-0 bottom-0 bg-transparent cursor-pointer"
  >
    <div class="p-1 pt-1.5">
      <ruby-logo />
    </div>
  </div>

  <!--  No request yet, the debugbar is full width but empty  -->
  <div
    v-if="!state.minimized && requestsStore.currentRequest == null"
    class="z-[9999] text-stone-900 fixed left-0 bottom-0 w-full"
  >
    <div class="h-0.5 bg-red-700 cursor-row-resize" />
    <div class="flex items-center justify-between bg-stone-100 border-b border-stone-200">
      <div class="px-5 py-1.5 italic">No request yet</div>
      <div class="px-3 space-x-2">
        <button
          v-if="configStore.config.mode == 'poll'"
          @click="togglePolling"
          :title="state.isPolling ? 'Pause polling' : 'Resume polling'"
        >
          <pause-icon v-if="state.isPolling" class="size-4" />
          <play-icon v-if="!state.isPolling" class="size-4" />
        </button>
        <button @click="state.minimized = true" title="Hide in the corner">
          <arrow-down-left-icon class="size-4" />
        </button>
      </div>
    </div>
  </div>

  <!--  The glorious debugbar  -->
  <div
    v-if="!state.minimized && requestsStore.currentRequest"
    class="z-[9999] text-stone-900 fixed left-0 bottom-0 w-full"
  >
    <div id="draggable-bar" @mousedown="state.isResizing = true" class="h-0.5 bg-red-700 cursor-row-resize" />

    <div
      id="debugbar-header"
      ref="header"
      class="flex flex-wrap-reverse justify-end px-1 items-center bg-stone-100 border-b-2 border-stone-300"
    >
      <!--  Left  -->
      <div class="flex grow">
        <div @click="state.minimized = true" class="p-1 pt-1.5">
          <ruby-logo />
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

      <!--  Right  -->
      <div class="flex flex-wrap-reverse justify-end items-center space-x-3 pr-1">
        <div class="flex space-x-2">
          <request-timings :request="requestsStore.currentRequest" />
        </div>

        <div @click="setActiveTab('request')" class="flex space-x-2 cursor-pointer">
          <span class="text-sm text-stone-600 font-medium tracking-wide">
            {{ requestsStore.currentRequest.routeAlias }}
          </span>

          <status-code :code="requestsStore.currentRequest.meta.status" />
        </div>

        <div class="flex items-center">
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

          <div class="flex items-center pl-1 space-x-2">
            <button @click="clearRequests" title="Clear all requests (frontend and backend)">
              <trash-icon class="size-4" />
            </button>
            <button
              v-if="configStore.config.mode == 'poll'"
              @click="togglePolling"
              :title="state.isPolling ? 'Pause polling' : 'Resume polling'"
            >
              <pause-icon v-if="state.isPolling" class="size-4" />
              <play-icon v-if="!state.isPolling" class="size-4" />
            </button>
            <button v-if="!isOpen" @click="state.minimized = true" title="Hide in the corner">
              <arrow-down-left-icon class="size-4" />
            </button>
            <button v-if="isOpen" @click="state.activeTab = ''" title="Close">
              <x-circle-icon class="size-4" />
            </button>
          </div>
        </div>
      </div>
    </div>

    <debugbar-body
      v-if="state.activeTab != ''"
      :style="`height: ${state.height}px`"
      :request="requestsStore.currentRequest"
      :activeTab="state.activeTab"
    />
  </div>
</template>
