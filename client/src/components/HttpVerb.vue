<script setup lang="ts">
const props = defineProps<{
  verb: string
}>()
</script>

<template>
  <div
    class="text-white font-medium px-1.5 py-1 rounded text-xs"
    :class="{
      'bg-sky-600': props.verb.toLowerCase() == 'get',
      'bg-indigo-600': props.verb.toLowerCase() == 'post',
      'bg-purple-500': props.verb.toLowerCase() == 'put',
      'bg-violet-400': props.verb.toLowerCase() == 'patch',
      'bg-red-700': props.verb.toLowerCase() == 'delete',
    }"
    v-text="props.verb.toUpperCase()"
  ></div>
</template>
