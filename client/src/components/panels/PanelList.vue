<script setup lang="ts">
import Panel from "@/components/panels/Panel.vue"
</script>

<template>
  <panel>
    <div class="flex flex-col space-y-8">
      <slot />
    </div>
  </panel>
</template>
