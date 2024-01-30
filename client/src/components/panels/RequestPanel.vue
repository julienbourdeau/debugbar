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
          <row label="Header: Version">
            {{ request.request.headers["Version"] }}
          </row>
          <row label="Header: Cache-Control">
            {{ request.request.headers["Cache-Control"] }}
          </row>
        </key-value-table>

        <foldable class="py-4" label="All Headers">
          <key-value-table>
            <row v-for="(v, k) in request.request.headers" :key="k" :label="k as unknown as string">{{ v }}</row>
          </key-value-table>
        </foldable>

        <div class="py-3 text-right italic text-sm text-stone-500">
          What else would like to see here?
          <a target="_blank" class="underline font-bold" href="https://github.com/julienbourdeau/debugbar/discussions"
            >Tell me!</a
          >
        </div>
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
      </panel>

      <panel>
        <h2 class="mt-0.5 mb-2 px-2 py-1 bg-stone-300 text-black tracking-wide text-xs uppercase font-bold rounded">
          HTTP Response
        </h2>

        <div v-if="!request.response?.status">
          <div class="py-3 text-sm text-stone-500">
            The response was not captured.
            <a target="_blank" class="underline font-bold" href="https://debugbar.dev/docs/known-limitations/"
              >Learn more</a
            >
          </div>
        </div>

        <div v-if="request.response?.status">
          <key-value-table>
            <row label="Status">{{ request.response.status }}</row>
            <row label="Body">{{ request.response.body.substring(0, 140) }}</row>
            <row label="Header: Content-Type">
              {{ request.response.headers["Content-Type"] }}
            </row>
          </key-value-table>

          <foldable class="py-4" label="All Headers">
            <key-value-table>
              <row v-for="(v, k) in request.response.headers" :key="k" :label="k as unknown as string">{{ v }}</row>
            </key-value-table>
          </foldable>
        </div>
      </panel>
    </div>
  </div>
</template>
