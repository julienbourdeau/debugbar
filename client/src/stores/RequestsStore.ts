import { defineStore } from "pinia"
import { BackendRequest, BackendRequestData } from "@/models/Request.ts"

export let useRequestsStore = defineStore("requests", {
  state: () =>
    ({
      requests: [new BackendRequest(firstRequest()), new BackendRequest(secondRequest())],
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

function firstRequest(): BackendRequestData {
  return {
    id: "4b37dede-9f0c-4d01-ad41-7b412461b094",
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
      view_runtime: 11.987999896518886,
      db_runtime: 5.917000002227724,
      duration: 42.587000012397766,
      cpu_time: 30.1115,
      idle_time: 12.475500012397767,
      allocations: 27964,
    },
    models: {
      Post: 10,
      PostAuthor: 73,
      Author: 72,
    },
    queries: [
      {
        name: "Post Load (1.4ms)",
        sql: "SELECT `posts`.* FROM `posts` ORDER BY `posts`.`id` DESC LIMIT 10 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 1.4,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:5", " `post_list'"],
      },
      {
        name: "PostAuthor Load (0.7ms)",
        sql: "SELECT `post_authors`.* FROM `post_authors` WHERE `post_authors`.`post_id` IN (5000, 4999, 4998, 4997, 4996, 4995, 4994, 4993, 4992, 4991) /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.7,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:5", " `post_list'"],
      },
      {
        name: "Author Load (0.5ms)",
        sql: "SELECT `authors`.* FROM `authors` WHERE `authors`.`id` IN (1325, 652, 1205, 1252, 1007, 1611, 641, 1695, 1433, 1639, 1733, 348, 497, 54, 887, 1934, 1995, 993, 352, 1679, 987, 1644, 1603, 182, 740, 876, 742, 1352, 1293, 1918, 184, 1757, 1884, 1104, 203, 255, 1834, 930, 1341, 1199, 768, 1192, 1643, 991, 687, 1149, 973, 1026, 1214, 1972, 1327, 1266, 612, 379, 1458, 1652, 1483, 1245, 1169, 1459, 1143, 1532, 9, 1859, 1530, 74, 1003, 965, 1993, 1699, 1616, 223) /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.5,
        lock_wait: null,
        binds: null,
        source: ["/Users/julien.bourdeau/Personal/rails/demo_app/app/controllers/demo_controller.rb:5", " `post_list'"],
      },
      {
        name: "Reaction Count (0.6ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4991 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.6,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.3ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4992 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4993 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.3ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4994 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.3,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
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
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4996 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.2ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4997 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.2,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.4ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4998 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.4,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
        ],
      },
      {
        name: "Reaction Count (0.2ms)",
        sql: "SELECT COUNT(*) FROM `reactions` WHERE `reactions`.`post_id` = 4999 /*action='post_list',application='DemoApp',controller='demo'*/",
        duration: 0.2,
        lock_wait: null,
        binds: null,
        source: [
          "/Users/julien.bourdeau/Personal/rails/demo_app/app/views/demo/post_list.html.erb:21",
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
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
          " `block in _app_views_demo_post_list_html_erb__1445890358838714043_25040'",
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
