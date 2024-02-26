import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"
import { resolve } from "path"

const entryFile = process.env.VITE_DEMO_MODE ? "./src/demo.ts" : "./src/main.ts"

const currentConfig = {
  entry: resolve(__dirname, entryFile),
  fileName: "debugbar.js",
}

const isNotReallyProd = () => {
  if (process.env.VITE_DEMO_MODE && process.env.NODE_ENV === "production") {
    return true
  }

  return process.env.NODE_ENV != "production"
}

// https://vitejs.dev/config/
export default defineConfig({
  define: {
    __VUE_PROD_DEVTOOLS__: isNotReallyProd(),
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
  ],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  build: {
    manifest: true,
    sourcemap: isNotReallyProd(),
    emptyOutDir: false,
    outDir: process.env.VITE_DEMO_MODE ? "./dist-demo" : "./dist",
    rollupOptions: {
      input: {
        debugbar: fileURLToPath(new URL(entryFile, import.meta.url)),
      },
    },
  },
})
