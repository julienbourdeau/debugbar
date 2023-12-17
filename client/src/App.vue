<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { ShadowRoot } from "vue-shadow-dom"
</script>

<template>
  <div>
    <shadow-root id="__debugbar-shadow-root">
      <debugbar></debugbar>
    </shadow-root>
  </div>
</template>
