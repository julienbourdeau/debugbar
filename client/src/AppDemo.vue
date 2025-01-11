<!-- This file is used when building the demo assets. -->
<!-- The demo is a self-contained version of the app with fixtures. It's meant to be displayed on debugbar.dev -->
<!-- The demo is built with `./build_demo.sh` which build the assets with the `vite.demo.config.ts` (via `npm run build:demo`) -->
<!-- The dedicated config allows is to have sourcemap and vite devtools. -->
<!-- This component load fixtures onMounted and show the app in a shadow DOM. -->

<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { ShadowRoot, ShadowStyle } from "vue-shadow-dom"
import { onMounted } from "vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequestData } from "@/models/Request.ts"

import css from "./style.css?inline"

onMounted(() => {
  console.log(`Using debugbar in DEMO mode`)

  const requests = import.meta.glob("../../fixtures/requests/*.json", { eager: true })
  const firstId = useRequestsStore().addRequests(Object.values(requests) as BackendRequestData[])[0]

  useRequestsStore().setCurrentRequestById(firstId)
})
</script>

<template>
  <div>
    <shadow-root id="__debugbar-shadow-root">
      <debugbar></debugbar>
      <shadow-style>
        {{ css }}
      </shadow-style>
    </shadow-root>
  </div>
</template>
