<!-- This is the main component of the debugbar. -->
<!--It's imported in the different App*.vue components.-->

<script setup lang="ts">
import { createConsumer } from "@rails/actioncable"
import { computed, reactive, ref } from "vue"
import { CodeBracketIcon, XCircleIcon, TrashIcon, PauseIcon, PlayIcon } from "@heroicons/vue/16/solid"

import TabButton from "@/components/TabButton.vue"
import ModelsPanel from "@/components/panels/ModelsPanel.vue"
import JobsPanel from "@/components/panels/JobsPanel.vue"
import LogsPanel from "@/components/panels/LogsPanel.vue"

import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { useConfigStore } from "@/stores/configStore.ts"
import CachePanel from "@/components/panels/CachePanel.vue"
import RequestPanel from "@/components/panels/RequestPanel.vue"
import JsonPanel from "@/components/panels/JsonPanel.vue"
import StatusCode from "@/components/ui/StatusCode.vue"
import PanelList from "@/components/panels/PanelList.vue"
import MessageItem from "@/components/messages/MessageItem.vue"
import QueryItem from "@/components/queries/QueryItem.vue"
import RequestTimings from "@/components/RequestTimings.vue"
import RequestListItem from "@/components/RequestListItem.vue"
import HttpVerb from "@/components/HttpVerb.vue"

let requestsStore = useRequestsStore()
let configStore = useConfigStore()

const header = ref(null)

const state = reactive({
  activeTab: "",
  isPolling: configStore.config.mode === "poll",
})

const defaultTabName = "queries"

const isActive = computed(() => {
  return state.activeTab != ""
})

const devMode = computed(() => {
  return import.meta.env.DEV
})

const routeAlias = computed(() => {
  return requestsStore.currentRequest?.meta.params.controller + "#" + requestsStore.currentRequest?.meta.params.action
})

let debugbarChannel = null

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

        if (!isActive.value) {
          requestsStore.setCurrentRequestById(ids[ids.length - 1])
        }

        setTimeout(() => {
          debugbarChannel.send({ ids: ids })
        }, 50)
      },
    }
  )
} else if (configStore.config.mode === "poll") {
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

        if (!isActive.value) {
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

const setActiveTab = (tab) => {
  state.activeTab = tab
}
</script>

<template>
  <!--  No request yet, the debugbar is full width but empty  -->
  <div v-if="requestsStore.currentRequest == null">
    <div class="px-5 py-1.5 italic">No request yet</div>
  </div>

  <div v-if="requestsStore.currentRequest" class="z-[9999] text-stone-900 w-full">
    <div
      id="debugbar-header"
      ref="header"
      class="flex flex-col px-1 items-center justify-between bg-stone-100 border-b-2 border-stone-300"
    >
      <!--      THE LIST-->
      <div v-if="!isActive" class="w-full space-y-1">
        <div
          v-for="r in requestsStore.requests"
          @click="
            (_event) => {
              requestsStore.setCurrentRequestById(r.id)
              state.activeTab = defaultTabName
            }
          "
        >
          <request-list-item :request="r" />
        </div>
      </div>

      <!--      THE PANEL-->
      <div v-if="isActive" class="w-full">
        <div class="flex w-full justify-between items-center">
          <div class="flex item-center space-x-3 py-2 border-0">
            <http-verb :verb="requestsStore.currentRequest.meta.method" />
            <span>{{ requestsStore.currentRequest.meta.path }}</span>
          </div>

          <button
            v-if="configStore.config.mode == 'poll'"
            @click="togglePolling"
            :title="state.isPolling ? 'Pause polling' : 'Resume polling'"
          >
            <pause-icon v-if="state.isPolling" class="size-4" />
            <play-icon v-if="!state.isPolling" class="size-4" />
          </button>

          <button @click="state.activeTab = ''" title="Close">
            <x-circle-icon class="size-4" />
          </button>
        </div>

        <div class="flex w-full justify-between items-center">
          <div class="flex items-center">
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

          <div class="flex items-center space-x-3">
            <request-timings :current-request="requestsStore.currentRequest" />

            <div @click="setActiveTab('request')" class="flex cursor-pointer">
              <span class="text-sm text-stone-600 font-medium tracking-wide">
                {{ routeAlias }}
              </span>
              <status-code :code="requestsStore.currentRequest.meta.status" class="ml-3" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!--    TODO: extract this to dedicated component ?-->
    <div ref="body" id="debugbar-body" class="bg-white overflow-scroll" v-if="state.activeTab != ''">
      <request-panel v-if="state.activeTab == 'request'" :request="requestsStore.currentRequest" />
      <panel-list v-if="state.activeTab == 'messages'">
        <message-item v-for="msg in requestsStore.currentRequest?.messages" :msg="msg" :key="msg.id" />
      </panel-list>
      <models-panel
        v-if="state.activeTab == 'models'"
        :models="requestsStore.currentRequest?.models"
        :count="requestsStore.currentRequest?.modelsCount"
      />
      <panel-list v-if="state.activeTab == 'queries'">
        <query-item v-for="query in requestsStore.currentRequest.queries" :key="query.id" :query="query" />
      </panel-list>
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
