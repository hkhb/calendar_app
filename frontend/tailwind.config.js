/** @type {import('tailwindcss').Config} */
module.exports = {
  mode: 'jit', // JIT モードを有効化
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
