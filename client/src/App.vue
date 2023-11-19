<script setup lang="ts">
import { ref } from 'vue'
import TabButton from "./components/TabButton.vue";
import ModelPanel from "./components/panels/ModelPanel.vue";
import QueriesPanel from "./components/panels/QueriesPanel.vue";
import {useRequestsStore} from "./stores/RequestsStore.ts";

let requestsStore = useRequestsStore()

const active = ref('queries')

const summary = {
  models: {
    title: 'Models',
    count: 31,
  },
  queries: {
    title: 'Queries',
    count: 4,
  },
  jobs: {
    title: 'Jobs',
    count: 0,
  },
}

const models = {
  'User': 10,
  'Post': 21,
  'Comment': 0,
}
</script>

<template>
  <div class="flex items-center justify-between font-mono bg-stone-100 border-b border-stone-200">
    <div class="flex ">
      <tab-button v-for="(v, k) in summary" :name="k" :count="v.count" :active="active" @active-tab="active = $event.name" />
    </div>

    <div>{{ requestsStore.requests[0].meta.controller }}#{{ requestsStore.requests[0].meta.action }}</div>
  </div>

  <model-panel :models="models" v-if="active == 'models'" />

  <queries-panel v-if="active == 'queries'" />
</template>
