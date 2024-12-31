<script setup lang="ts">
import { ShadowRoot, ShadowStyle } from "vue-shadow-dom"
import { onMounted } from "vue"

import css from "./style.css?inline"
import Devtools from "@/devtools/Devtools.vue"

onMounted(() => {
  console.log(`Using debugbar in DEVTOOLS !!`)
})
</script>

<template>
  <div>
    <!-- Shadow DOM is not necessary but I'm not too sure how to load the styles otherwise.😅-->
    <shadow-root id="__debugbar-shadow-root">
      <devtools></devtools>
      <shadow-style>
        {{ css }}
      </shadow-style>
    </shadow-root>
  </div>
</template>
