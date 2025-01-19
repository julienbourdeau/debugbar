const version = "0.1.1"

const manifest: chrome.runtime.Manifest = {
  // background: {
  //   service_worker: "extension/background.js",
  // },
  // options_page: "extension/options.html",
  description:
    "Get a better understanding of your application performance and behavior with the debugbar devtools panel.",
  icons: {
    16: "extension/icons/ror-icon-16.png",
    48: "extension/icons/ror-icon-48.png",
    128: "extension/icons/ror-icon-128.png",
  },
  manifest_version: 3,
  name: "Debugbar - Devtools for Ruby on Rails",
  permissions: ["scripting", "webRequest", "activeTab", "tabs"],
  devtools_page: "extension/devtools.html",
  host_permissions: ["<all_urls>"],
  version: version,
}

export default manifest
