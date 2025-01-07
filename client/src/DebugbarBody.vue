<script setup lang="ts">
import QueryItem from "@/components/queries/QueryItem.vue"
import JsonPanel from "@/components/panels/JsonPanel.vue"
import CachePanel from "@/components/panels/CachePanel.vue"
import LogsPanel from "@/components/panels/LogsPanel.vue"
import PanelList from "@/components/panels/PanelList.vue"
import JobsPanel from "@/components/panels/JobsPanel.vue"
import RequestPanel from "@/components/panels/RequestPanel.vue"
import MessageItem from "@/components/messages/MessageItem.vue"
import ModelsPanel from "@/components/panels/ModelsPanel.vue"
import { BackendRequest } from "@/models/Request.ts"
import HttpPanel from "@/components/panels/HttpPanel.vue"

withDefaults(
  defineProps<{
    activeTab: string
    request: BackendRequest
  }>(),
  { activeTab: "" }
)
</script>

<template>
  <div ref="body" id="debugbar-body" class="bg-white overflow-scroll">
    <panel-list v-if="activeTab == 'messages'">
      <message-item v-for="msg in request?.messages" :msg="msg" :key="msg.id" />
    </panel-list>
    <models-panel v-if="activeTab == 'models'" :models="request?.models" :count="request?.modelsCount" />
    <panel-list v-if="activeTab == 'queries'">
      <query-item v-for="query in request.queries" :key="query.id" :query="query" />
    </panel-list>
    <jobs-panel v-if="activeTab == 'jobs'" :jobs="request?.jobs" />
    <cache-panel v-if="activeTab == 'cache'" :cache="request?.cache" />
    <logs-panel v-if="activeTab == 'logs'" :logs="request?.logs" />
    <http-panel v-if="activeTab == 'http'" :requests="request.httpCalls" />
    <request-panel v-if="activeTab == 'request'" :request="request" />
    <json-panel v-if="activeTab == 'debug'" :request="request" class="px-3 py-2" />
  </div>
</template>
