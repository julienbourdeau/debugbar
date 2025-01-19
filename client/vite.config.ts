import { fileURLToPath, URL } from "node:url"

import { defineConfig } from "vite"
import vue from "@vitejs/plugin-vue"

const isNotProd = () => process.env.NODE_ENV != "production"

// https://vitejs.dev/config/
export default defineConfig({
  define: {
    __VUE_PROD_DEVTOOLS__: isNotProd(),
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
    sourcemap: isNotProd(),
    emptyOutDir: true,
    outDir: "./dist",
    rollupOptions: {
      output: {
        inlineDynamicImports: true, // Ensure debugbar-[xx].js contains everything
      },
      input: {
        debugbar: fileURLToPath(new URL("./src/main.ts", import.meta.url)),
      },
    },
  },
})
