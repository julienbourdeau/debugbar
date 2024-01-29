<script setup lang="ts">
import omit from "lodash/omit"
import Panel from "@/components/panels/Panel.vue"
import { BackendRequest } from "@/models/Request.ts"
import KeyValueTable from "@/components/ui/KeyValueTable.vue"
import Row from "@/components/ui/Row.vue"
import Foldable from "@/components/ui/Foldable.vue"

defineProps<{
  request: BackendRequest
}>()
</script>

<template>
  <div class="flex">
    <div class="w-1/2">
      <panel>
        <h2 class="mt-0.5 mb-2 px-2 py-1 bg-stone-300 text-black tracking-wide text-xs uppercase font-bold rounded">
          HTTP Request
        </h2>

        <key-value-table>
          <row label="Method">{{ request.meta.method }}</row>
          <row label="URL">{{ request.meta.path }}</row>
          <row label="Params">
            <highlightjs
              class="text-sm"
              language="json"
              :code="JSON.stringify(omit(request.meta.params, ['controller', 'action']), null, 2)"
            />
          </row>
        </key-value-table>

        <foldable class="py-2" label="Headers">
          <key-value-table>
            <row v-for="(v, k) in request.request.headers" :key="k" :label="k as unknown as string">{{ v }}</row>
          </key-value-table>
        </foldable>
      </panel>
    </div>

    <div class="w-1/2">
      <panel>
        <h2 class="mt-0.5 mb-2 px-2 py-1 bg-stone-300 text-black tracking-wide text-xs uppercase font-bold rounded">
          Routing
        </h2>

        <key-value-table>
          <row title="Controller"> {{ request.meta.controller }} > {{ request.meta.action }} </row>
        </key-value-table>

        <div class="text-right italic text-sm text-stone-400">
          What else would like to see here?
          <a class="underline font-bold" href="https://github.com/julienbourdeau/debugbar/discussions">Tell me!</a>
        </div>
      </panel>

      <panel>
        <h2 class="mt-0.5 mb-2 px-2 py-1 bg-stone-300 text-black tracking-wide text-xs uppercase font-bold rounded">
          HTTP Response
        </h2>
      </panel>
    </div>
  </div>
</template>
