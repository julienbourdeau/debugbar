import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"
import webExtension from "@samrum/vite-plugin-web-extension"

const isNotProd = () => process.env.NODE_ENV != "production"

// https://vitejs.dev/config/
export default defineConfig({
  define: {
    __VUE_PROD_DEVTOOLS__: isNotProd(),
  },
  plugins: [
    vue({
      template: {
        compilerOptions: {
          // This is because I embed the ruby logo SVG as a vue component.
          // There is probably a better way.
          isCustomElement: (tag) => tag.includes(":"),
        },
      },
    }),
    webExtension({
      manifest: {
        // background: {
        //   service_worker: "extension/background.js",
        // },
        // options_page: "extension/options.html",
        description: "Get a better understanding of your application performance and behavior with the debugbar.",
        icons: {
          "16": "extension/icons/debugbar-icon-16.png",
          "48": "extension/icons/ror-icon-48.png",
          "128": "extension/icons/ror-icon-128.png",
        },
        manifest_version: 3,
        name: "Debugbar for Ruby on Rails",
        permissions: ["scripting", "webRequest", "activeTab"],
        devtools_page: "extension/devtools/index.html",
        host_permissions: ["http://localhost:3000/*", "http://127.0.0.1:3000/*", "ws://127.0.0.1:3000/*"],
        version: "0.6.1",
      },
    }),
  ],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  build: {
    manifest: true,
    sourcemap: isNotProd(),
    emptyOutDir: true,
    outDir: "./dist-extension",
    rollupOptions: {
      // output: {
      //   inlineDynamicImports: true,
      // },
      input: {
        devpanel: fileURLToPath(new URL("./src/devtools-panel.ts", import.meta.url)),
      },
    },
  },
})
