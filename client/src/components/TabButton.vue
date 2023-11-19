<script setup lang="ts">
const props = defineProps<{
  name: String,
  count: Number,
  active: String,
}>()
</script>

<template>
  <div class="px-3 py-1.5 cursor-pointer" @click="$emit('active-tab', {name})">
    {{ props.name }}
    <span v-if="props.count == 0" class="rounded-full bg-stone-100 text-stone-800 p-1.5 border border-stone-200">0</span>
    <span v-if="props.count > 0" class="rounded-full bg-amber-100 text-amber-800 p-1.5 border border-amber-200" v-text="props.count" />
  </div>
</template>

<style scoped>

</style>
