<!-- This is the component used the build the final production assets. -->
<!-- It's primary used to load the app in the shadow DOM -->
<!-- See vite.config.ts and other App*.vue for details -->

<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { ShadowRoot, ShadowStyle } from "vue-shadow-dom"

import css from "./style.css?inline"
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
