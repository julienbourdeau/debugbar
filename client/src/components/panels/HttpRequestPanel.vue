<script setup lang="ts">
import Panel from "@/components/panels/Panel.vue"
import Row from "@/components/ui/Row.vue"
import KeyValueTable from "@/components/ui/KeyValueTable.vue"
import Foldable from "@/components/ui/Foldable.vue"
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
      <row label="Header: Version">
        {{ request.headers["Version"] }}
      </row>
      <row label="Header: Cache-Control">
        {{ request.headers["Cache-Control"] }}
      </row>
    </key-value-table>

    <foldable class="py-4" label="All Headers">
      <key-value-table>
        <row v-for="(v, k) in request.headers" :key="k" :label="k as unknown as string">{{ v }}</row>
      </key-value-table>
    </foldable>
  </panel>
</template>
