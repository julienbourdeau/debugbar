<script setup lang="ts">
import Panel from "@/components/panels/Panel.vue"
import Row from "@/components/ui/Row.vue"
import KeyValueTable from "@/components/ui/KeyValueTable.vue"
import { HttpRequest } from "@/models/Request.ts"
import JsonCode from "@/components/ui/JsonCode.vue"
import SubHeading from "@/components/ui/SubHeading.vue"
import HttpVerb from "@/components/ui/HttpVerb.vue"
import { extractQueryParams } from "@/helpers.ts"

defineProps<{
  request: HttpRequest
}>()
</script>

<template>
  <panel>
    <sub-heading>HTTP Request</sub-heading>

    <key-value-table>
      <row label="Method"><http-verb :verb="request.method" /></row>
      <row label="URL" class="font-mono">{{ request.url.href }}</row>
      <row label="Params">
        <json-code :json="extractQueryParams(request.url)" />
      </row>
      <row v-for="(v, k) in request.headers" :key="k" :label="k as unknown as string">{{ v }}</row>
    </key-value-table>
  </panel>
</template>
