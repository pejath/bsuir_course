module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        'title': ['Josefin Sans', 'sans-serif'],
      },
      colors: {
        'primary': {
          500: 'rgb(191 122 118)',
        },
        'neutral': {
          // ... цвета из исходного файла
        },
        'text-base': '#d1d1d1',
        'text-link': '#e5e5e5',
      },
      textColor: {
        'link': '#e5e5e5',
        'link-hover': '#ffffff',
      }
    }
  }
} 