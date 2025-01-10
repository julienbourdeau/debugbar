import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"

// https://vitejs.dev/config/
export default defineConfig({
  define: {
    __VUE_PROD_DEVTOOLS__: true, // nice for demo mode
    __DEBUBGBAR_MODE__: "web",
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
    sourcemap: true, // very nice for demo mode
    emptyOutDir: false,
    outDir: "./dist-demo",
    rollupOptions: {
      input: {
        debugbar: fileURLToPath(new URL("./src/demo.ts", import.meta.url)),
      },
    },
  },
})
