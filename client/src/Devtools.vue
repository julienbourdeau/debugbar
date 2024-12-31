<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { ShadowRoot, ShadowStyle } from "vue-shadow-dom"
import { onMounted } from "vue"

import css from "./style.css?inline"

onMounted(() => {
  console.log(`Using debugbar in DEVTOOLS !!`)
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
