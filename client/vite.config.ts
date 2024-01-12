import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"
import { resolve } from "path"

const currentConfig = {
  entry: resolve(__dirname, "./src/main.ts"),
  fileName: "debugbar.js",
}

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  build: {
    manifest: true,
    sourcemap: true,
    emptyOutDir: false,
    outDir: process.env.VITE_DEMO_MODE ? "./dist-demo" : "./dist",
    rollupOptions: {
      input: {
        debugbar: fileURLToPath(new URL("./src/main.ts", import.meta.url)),
        // debugbarDemoMode: fileURLToPath(new URL("./src/demo.ts", import.meta.url)),
      },
    },
  },
})
