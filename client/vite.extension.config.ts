import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"
import webExtension from "@samrum/vite-plugin-web-extension"
import manifest from "./extension/manifest"

const isNotProd = () => process.env.NODE_ENV != "production"

// https://vitejs.dev/config/
export default defineConfig({
  define: {
    __VUE_PROD_DEVTOOLS__: isNotProd(),
    __DEBUBGBAR_MODE__: "extension",
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
      manifest,
    }),
  ],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  build: {
    manifest: false,
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
