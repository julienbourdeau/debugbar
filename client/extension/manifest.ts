const manifest: chrome.runtime.Manifest = {
  // background: {
  //   service_worker: "extension/background.js",
  // },
  // options_page: "extension/options.html",
  description: "Get a better understanding of your application performance and behavior with the debugbar.",
  icons: {
    16: "extension/icons/debugbar-icon-16.png",
    48: "extension/icons/ror-icon-48.png",
    128: "extension/icons/ror-icon-128.png",
  },
  manifest_version: 3,
  name: "Debugbar for Ruby on Rails",
  permissions: ["scripting", "webRequest", "activeTab"],
  devtools_page: "extension/devtools.html",
  host_permissions: ["http://localhost:3000/*", "http://127.0.0.1:3000/*", "ws://127.0.0.1:3000/*"],
  version: "0.6.1",
}

export default manifest
