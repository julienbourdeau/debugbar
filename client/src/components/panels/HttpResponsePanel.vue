<script setup lang="ts">
import { HttpResponse } from "@/models/Request.ts"
import Panel from "@/components/panels/Panel.vue"
import KeyValueTable from "@/components/ui/KeyValueTable.vue"
import Row from "@/components/ui/Row.vue"
import Foldable from "@/components/ui/Foldable.vue"
import SubHeading from "@/components/ui/SubHeading.vue"
import StatusCode from "@/components/ui/StatusCode.vue"

defineProps<{
  response: HttpResponse
}>()
</script>

<template>
  <panel>
    <sub-heading>HTTP Response</sub-heading>

    <key-value-table>
      <row label="Status"><status-code :code="response.status" /></row>
      <row label="Body">{{ response.body.substring(0, 140) }}</row>
      <row label="Content-Type">
        {{ response.headers["Content-Type"] }}
      </row>
    </key-value-table>

    <foldable class="py-4" label="All Headers">
      <key-value-table>
        <row v-for="(v, k) in response.headers" :key="k" :label="k as unknown as string">{{ v }}</row>
      </key-value-table>
    </foldable>
  </panel>
</template>
