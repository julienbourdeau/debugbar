<script setup lang="ts">
import { onMounted } from "vue"
import Devtools from "@/devtools/Devtools.vue"

onMounted(() => {
  console.log(`Using debugbar in browser devtools! 😎`)
})
</script>

<template>
  <div>
    <devtools></devtools>
  </div>
</template>
