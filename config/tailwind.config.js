const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
        pop: ['Mochiy Pop One', 'sans-serif'],
        meiryo: ['メイリオ', 'Meiryo','Hiragino Kaku Gothic ProN','ヒラギノ角ゴ ProN W3','ＭＳ Ｐゴシック','MS PGothic', 'MS UI Gothic','Helvetica','Arial']
      },
      colors: {
        'yamanote-green': {
          50: '#D7DDD1',
          100: '#6F9142',
          200: '#374821'
        },
        'bright-orange': {
          50: '#f2bf91',
          100: '#FD5B40',
          200: '#cc6206'
        },
        'dark-blue': {
          50: '#e6f8ff',
          100: '#CAE7F2',
          200: '#007FB1'
        }
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
