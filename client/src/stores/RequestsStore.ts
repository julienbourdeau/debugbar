import { defineStore } from "pinia"
import type { BackendRequest } from "@/models/Request.ts"

export let useRequestsStore = defineStore("requests", {
  state: () =>
    ({
      requests: [firstRequest(), secondRequest()],
      currentRequestId: firstRequest().id,
    }) as {
      requests: BackendRequest[]
      currentRequestId: string
    },
  actions: {
    addRequest(request: BackendRequest) {
      this.requests.push(request)
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

function firstRequest() {
  return {
    id: "1f3c6c58-6b16-46d4-978d-23e3f7d7f5a8",
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
      view_runtime: 19.64299997780472,
      db_runtime: 5.898000090382993,
    },
    models: {
      Post: 10,
      PostAuthor: 73,
      Author: 72,
    },
    queries: [
      {
        name: "Post Load (0.4ms)",
        sql: "SELECT `posts`.* FROM `posts` ORDER BY `posts`.`id` DESC LIMIT 10 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:3", " `post_list'"],
      },
      {
        name: "PostAuthor Load (0.5ms)",
        sql: "SELECT `post_authors`.* FROM `post_authors` WHERE `post_authors`.`post_id` IN (5000, 4999, 4998, 4997, 4996, 4995, 4994, 4993, 4992, 4991) /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.5,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:3", " `post_list'"],
      },
      {
        name: "Author Load (0.5ms)",
        sql: "SELECT `authors`.* FROM `authors` WHERE `authors`.`id` IN (1325, 652, 1205, 1252, 1007, 1611, 641, 1695, 1433, 1639, 1733, 348, 497, 54, 887, 1934, 1995, 993, 352, 1679, 987, 1644, 1603, 182, 740, 876, 742, 1352, 1293, 1918, 184, 1757, 1884, 1104, 203, 255, 1834, 930, 1341, 1199, 768, 1192, 1643, 991, 687, 1149, 973, 1026, 1214, 1972, 1327, 1266, 612, 379, 1458, 1652, 1483, 1245, 1169, 1459, 1143, 1532, 9, 1859, 1530, 74, 1003, 965, 1993, 1699, 1616, 223) /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.5,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:3", " `post_list'"],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4991 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4992 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.6ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4993 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.6,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4994 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.3ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4995 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.6ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4996 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.6,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.3ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4997 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.8ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4998 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.8,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.3ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4999 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
      {
        name: "Reaction Count (0.5ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 5000 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.5,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__2049320308328158073_25040'",
        ],
      },
    ],
  }
}

function secondRequest() {
  return {
    id: "4aca6827-3612-4c9d-b8df-df855051f8a7",
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
      view_runtime: 3.1789999920874834,
      db_runtime: 0.0,
    },
    models: {},
    queries: [
      {
        name: "ActiveRecord::SchemaMigration Load (11.3ms)",
        sql: "SELECT `schema_migrations`.`version` FROM `schema_migrations` ORDER BY `schema_migrations`.`version` ASC /*application='DemoApp'*/",
        duration: 11.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/debugbar_rb/lib/debugbar_rb/middlewares/request_metrics.rb:10",
          " `call'",
        ],
      },
    ],
  }
}
