import { defineStore } from "pinia"
import { BackendRequest, BackendRequestData } from "@/models/Request.ts"

export let useRequestsStore = defineStore("requests", {
  state: () =>
    ({
      requests: [new BackendRequest(secondRequest())],
      currentRequestId: secondRequest().id,
    }) as {
      requests: BackendRequest[]
      currentRequestId: string
    },
  actions: {
    addRequests(requests: BackendRequest[]): string[] {
      const ids = []
      requests.forEach((r) => {
        this.requests.push(new BackendRequest(r))
        ids.push(r.id)
      })

      this.setCurrentRequestId(ids[ids.length - 1])

      return ids
    },
    setCurrentRequestId(id: string) {
      this.currentRequestId = id
    },
    getCurrentRequest(): BackendRequest {
      return this.requests.find((r) => r.id === this.currentRequestId)!
    },
    // removeRequest(request) {
    //   this.requests.splice(this.requests.indexOf(request), 1)
    // },
  },
})

function firstRequest(): BackendRequestData {
  return {
    id: "f9fd5ad9-e588-4966-9f93-642caa44174c",
    meta: {
      controller: "DemoController",
      action: "post_list",
      params: {
        controller: "demo",
        action: "post_list",
      },
      format: "html",
      method: "GET",
      path: "/post_list",
      status: 200,
      view_runtime: 59.9490002496168,
      db_runtime: 41.776999598369,
      duration: 757.220999956131,
      cpu_time: 650.6885,
      idle_time: 106.532499956131,
      allocations: 1077497,
    },
    models: {
      Post: 10,
      PostAuthor: 73,
      Author: 72,
    },
    queries: [
      {
        name: "ActiveRecord::SchemaMigration Load (0.4ms)",
        sql: "SELECT `schema_migrations`.`version` FROM `schema_migrations` ORDER BY `schema_migrations`.`version` ASC ",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/debugbar_rb/lib/debugbar_rb/middlewares/track_current_request.rb:10",
          " `call'",
        ],
      },
      {
        name: "Post Load (0.2ms)",
        sql: "SELECT `posts`.* FROM `posts` ORDER BY `posts`.`id` DESC LIMIT 10 ",
        duration: 0.2,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:5", " `post_list'"],
      },
      {
        name: "PostAuthor Load (0.7ms)",
        sql: "SELECT `post_authors`.* FROM `post_authors` WHERE `post_authors`.`post_id` IN (5000, 4999, 4998, 4997, 4996, 4995, 4994, 4993, 4992, 4991) ",
        duration: 0.7,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:5", " `post_list'"],
      },
      {
        name: "Author Load (0.8ms)",
        sql: "SELECT `authors`.* FROM `authors` WHERE `authors`.`id` IN (1325, 652, 1205, 1252, 1007, 1611, 641, 1695, 1433, 1639, 1733, 348, 497, 54, 887, 1934, 1995, 993, 352, 1679, 987, 1644, 1603, 182, 740, 876, 742, 1352, 1293, 1918, 184, 1757, 1884, 1104, 203, 255, 1834, 930, 1341, 1199, 768, 1192, 1643, 991, 687, 1149, 973, 1026, 1214, 1972, 1327, 1266, 612, 379, 1458, 1652, 1483, 1245, 1169, 1459, 1143, 1532, 9, 1859, 1530, 74, 1003, 965, 1993, 1699, 1616, 223) ",
        duration: 0.8,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:5", " `post_list'"],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4991 ",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (0.2ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4992 ",
        duration: 0.2,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (16.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4993 ",
        duration: 16.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (6.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4994 ",
        duration: 6.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (1.1ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4995 ",
        duration: 1.1,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4996 ",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (0.7ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4997 ",
        duration: 0.7,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (0.9ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4998 ",
        duration: 0.9,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4999 ",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
      {
        name: "Reaction Count (0.3ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 5000 ",
        duration: 0.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb___1955769724835336759_25040'",
        ],
      },
    ],
  }
}

function secondRequest(): BackendRequestData {
  return {
    id: "22775dc1-b86b-46e2-bc64-9268d2462713",
    meta: {
      controller: "Rails::WelcomeController",
      action: "index",
      params: {
        controller: "rails/welcome",
        action: "index",
      },
      format: "html",
      method: "GET",
      path: "/",
      status: 200,
      view_runtime: 1.180000021122396,
      db_runtime: 0.0,
      duration: 2.8529999256134033,
      cpu_time: 2.566499999999998,
      idle_time: 0.28649992561340554,
      allocations: 1151,
    },
    models: {},
    queries: [],
  }
}
