/** @type {import('tailwindcss').Config} */
export default {
  important: true,
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
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
