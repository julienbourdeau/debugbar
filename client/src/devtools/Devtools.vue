<!-- This is the main component of the debugbar. -->
<!--It's imported in the different App*.vue components.-->

<script setup lang="ts">
import { computed, onMounted, reactive } from "vue"
import { CodeBracketIcon, XMarkIcon, NoSymbolIcon } from "@heroicons/vue/16/solid"
import TabButton from "@/components/TabButton.vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import StatusCode from "@/components/ui/StatusCode.vue"
import RequestListItem from "@/components/RequestListItem.vue"
import RequestTimings from "@/components/RequestTimings.vue"
import HttpVerb from "@/components/ui/HttpVerb.vue"
import DebugbarBody from "@/DebugbarBody.vue"

let requestsStore = useRequestsStore()

const state = reactive({
  activeTab: "",
  isConnected: false,
  recentlyAdded: {},
})

const defaultTabName = "queries"

const isActive = computed(() => {
  return state.activeTab != ""
})

const devMode = computed(() => {
  return import.meta.env.DEV
})

const retrieveRequestData = (metadataUrl) => {
  fetch(metadataUrl)
    .then((response) => response.json())
    .then((data) => {
      requestsStore.addRequests([data])
      state.recentlyAdded[data.id] = true
      setTimeout(() => {
        state.recentlyAdded[data.id] = false // TODO: Delete instead?
      }, 750)
    })
}

const setupExtensionListener = () => {
  chrome.devtools.network.onRequestFinished.addListener((request) => {
    const metadataUrl = request.response.headers.find((header) => header.name === "x-debugbar-url")

    if (metadataUrl?.value) {
      console.log(`Valid request`, metadataUrl, request)
      retrieveRequestData(metadataUrl.value)
    } else if (devMode) {
      console.log(
        `Ignored request: ${request.request.method.toUpperCase()} ${request.request.url} (${request.response.status})`
      )
    }
  })
}

onMounted(() => {
  if (chrome !== undefined && chrome.devtools !== undefined) {
    setupExtensionListener()
  }
})

const clearRequests = () => {
  state.activeTab = ""
  requestsStore.clearRequests()
}

const setActiveTab = (tab) => {
  state.activeTab = tab
}
</script>

<template>
  <div class="">
    <!--    HEADER-->
    <div class="px-1 flex items-center justify-between w-full bg-stone-600 text-white">
      <div @click="setActiveTab('')" class="py-0.5 cursor-pointer">{{ requestsStore.requestCount }} requests</div>
      <div class="pl-1.5 flex items-center space-x-2">
        <button
          @click="clearRequests"
          title="Clear all requests (frontend and backend)"
          class="flex items-center space-x-1"
        >
          <no-symbol-icon class="size-3.5" /> <span class="text-xs uppercase">clear</span>
        </button>
        <button
          v-if="isActive"
          @click="setActiveTab('')"
          title="Close current request"
          class="flex items-center space-x-1"
        >
          <x-mark-icon class="size-4" /> <span class="text-xs uppercase">close</span>
        </button>
      </div>
    </div>

    <div v-if="requestsStore.requestCount > 0" class="z-[9999] text-stone-900 w-full">
      <div id="debugbar-header" class="flex flex-col items-center justify-between">
        <!--        EMPTY STATE-->
        <div v-if="requestsStore.requestCount == 0">
          <p class="px-1 py-2">
            No request detected yet.
            <a
              target="_blank"
              class="text-blue-700 font-medium underline"
              href="https://debugbar.dev/docs/troubleshooting/"
              >Troubleshooting docs</a
            >
          </p>
        </div>

        <!--      THE LIST-->
        <div v-if="!isActive" class="w-full">
          <table class="w-full">
            <thead>
              <tr>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <request-list-item
                :request="r"
                v-for="r in requestsStore.requests"
                class="cursor-pointer transition-colors duration-1000 hover:bg-stone-200"
                :class="{ 'bg-yellow-50 transition': state.recentlyAdded[r.id] }"
                @click="
                  (_event) => {
                    requestsStore.setCurrentRequestById(r.id)
                    state.activeTab = defaultTabName
                  }
                "
              />
            </tbody>
          </table>
        </div>

        <!--      THE PANEL-->
        <div v-if="isActive" class="w-full">
          <div class="flex w-full px-1 py-1 justify-between items-center bg-stone-100">
            <div class="w-full flex items-center">
              <http-verb :verb="requestsStore.currentRequest.meta.method" />
              <div
                class="pl-1 grow text-nowrap overflow-hidden font-mono"
                :title="requestsStore.currentRequest.meta.path"
              >
                {{ requestsStore.currentRequest.meta.path }}
              </div>

              <request-timings :request="requestsStore.currentRequest" />
            </div>
          </div>

          <div class="flex pt-1 pr-1 w-full justify-end flex-wrap-reverse items-center bg-stone-50">
            <div class="flex grow justify-start items-center">
              <tab-button
                v-for="(v, k) in requestsStore.currentRequest.dataForTabs"
                key="k"
                :label="v.label"
                :count="v?.count"
                :is-active="k === state.activeTab"
                :disabled="v.count == 0"
                @click="setActiveTab(k)"
                class="text-xs flex items-center space-x-1 px-2 py-1.5 border-0"
                :class="{
                  'bg-stone-200 rounded-t-sm cursor-auto': k === state.activeTab,
                }"
                >{{ v.label }}</tab-button
              >

              <button
                v-if="devMode"
                @click="setActiveTab('debug')"
                class="px-3 py-1.5 text-stone-600"
                :class="{ 'bg-stone-200': state.activeTab == 'debug' }"
              >
                <CodeBracketIcon class="size-4" />
              </button>
            </div>

            <div class="flex items-center space-x-3">
              <div @click="setActiveTab('request')" class="flex cursor-pointer">
                <span class="text-sm text-stone-600 font-medium tracking-wide">
                  {{ requestsStore.currentRequest.routeAlias }}
                </span>
                <status-code :code="requestsStore.currentRequest.meta.status" class="ml-3" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <debugbar-body :request="requestsStore.currentRequest" :active-tab="state.activeTab" />
    </div>
  </div>
</template>
