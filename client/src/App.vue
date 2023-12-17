<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { ShadowRoot } from "vue-shadow-dom"
</script>

<template>
  <div style="background: #22863a">
    <shadow-root id="mega-uniq-id">
      <debugbar></debugbar>
    </shadow-root>
  </div>
</template>
