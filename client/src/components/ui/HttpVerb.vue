<script setup lang="ts">
const props = defineProps<{
  verb: string
}>()
</script>

<template>
  <div
    class="px-1 py-0.5 rounded text-xs text-white"
    :class="{
      'bg-sky-700': props.verb.toLowerCase() == 'get',
      'bg-indigo-700': props.verb.toLowerCase() == 'post',
      'bg-purple-700': props.verb.toLowerCase() == 'put',
      'bg-violet-500': props.verb.toLowerCase() == 'patch',
      'bg-red-700': props.verb.toLowerCase() == 'delete',
    }"
    v-text="props.verb.toUpperCase()"
  ></div>
</template>
