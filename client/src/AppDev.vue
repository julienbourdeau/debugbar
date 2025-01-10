<!-- This file is used when developing the frontend. -->
<!-- ./index.html will load `dev.ts` which build the app with this AppDev.vue component. -->
<!-- This component makes pre-registered calls to a rails backend to load data so you can edit -->
<!--  the app and with HMR, you never have leave the page. -->
<!-- Use with `npm run dev` and open http://localhost:5173/ -->

<script setup lang="ts">
import Debugbar from "@/Debugbar.vue"
import { onMounted } from "vue"
import { useRequestsStore } from "@/stores/RequestsStore.ts"
import { BackendRequestData } from "@/models/Request.ts"
import { random } from "lodash"

onMounted(() => {
  if (import.meta.env.DEV && import.meta.env.VITE_LOAD_FIXTURES) {
    const requests = import.meta.glob("../../fixtures/requests/*.json", { eager: true })
    const lastId = useRequestsStore()
      .addRequests(Object.values(requests) as BackendRequestData[])
      .pop()
    useRequestsStore().setCurrentRequestById(lastId)
  }

  setTimeout(() => {
    // We use `no-cors` mode because we don't need the response, we just want to trigger the request,
    // the debugbar will receive the information related to these requests via websocket
    fetch("http://127.0.0.1:3000/post-list?with-external-data=true", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/random", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/api/jobs?name=refresh&post_id=" + random(1, 300), { mode: "no-cors" })
    // fetch("http://127.0.0.1:3000/api/jobs?name=send_email&post_id=" + random(1, 300), { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/api/errors?code=404", { mode: "no-cors" })
    // fetch("http://127.0.0.1:3000/api/errors?code=401", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/api/errors?code=500", { mode: "no-cors" })
    fetch("http://127.0.0.1:3000/a/very/deeply/nested/route-with-looong-path-to-test-UI?with=random-param#ok", {
      mode: "no-cors",
    })
  }, 600)

  //   setTimeout(() => {
  //     // We use `no-cors` mode because we don't need the response, we just want to trigger the request,
  //     // fetch("http://127.0.0.1:3000/topics", { mode: "no-cors" })
  //     fetch("http://127.0.0.1:3000/topics/random", { mode: "no-cors" })
  //     // fetch("http://127.0.0.1:3000/topics/slow", { mode: "no-cors" })
  //     fetch("http://127.0.0.1:3000/external-data?use_params=yes", { mode: "no-cors" })
  //   }, 600)
})
</script>

<template>
  <debugbar />
</template>
