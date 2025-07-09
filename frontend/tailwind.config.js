/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        nmi: {
          dark: "#3A5050",
          light: "#f8fafc",
          accent: "#FA650F",
        }
      }
    }
  },
  plugins: []
}
