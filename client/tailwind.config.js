/** @type {import('tailwindcss').Config} */
const content = ["./src/**/*.{vue,js,ts,jsx,tsx}"]

if (process.env.NODE_ENV === "development") {
  content.push("./dev/index.html")
}

export default {
  content: content,
  theme: {
    extend: {
      colors: {
        "red-rails": "#D30001",
        "gray-rails": "#F0E7E9",
      },
    },
  },
  plugins: [],
  corePlugins: {
    preflight: true,
  },
}
