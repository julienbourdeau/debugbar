<script setup lang="ts">
  const props = defineProps<{
    models: {[key: string]: Number}
  }>()
</script>

<template>
  <table class="table-fixed">
    <tr>
      <th>Model</th>
      <th>Count</th>
    </tr>
    <tr v-for="(v, k) in props.models">
      <td>{{ k }}</td>
      <td>{{ v }}</td>
    </tr>
  </table>
</template>

<style scoped>

</style>
