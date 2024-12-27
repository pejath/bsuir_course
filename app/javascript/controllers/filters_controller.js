import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["genre"]
  
  connect() {
    console.log("Filters controller connected")
    this.selectedGenres = []
  }

  toggle(event) {
    event.preventDefault()
    const genreId = event.currentTarget.dataset.genreId
    const button = event.currentTarget
    
    console.log("Toggle clicked for genre:", genreId)
    console.log("Current selected genres:", this.selectedGenres)
    
    if (this.selectedGenres.includes(genreId)) {
      this.selectedGenres = this.selectedGenres.filter(id => id !== genreId)
      button.classList.remove('bg-indigo-500', 'text-white')
      button.classList.add('bg-neutral-700')
    } else {
      this.selectedGenres.push(genreId)
      button.classList.remove('bg-neutral-700')
      button.classList.add('bg-indigo-500', 'text-white')
    }

    console.log("Selected genres after toggle:", this.selectedGenres)
    this.filter()
  }

  clearAll() {
    this.selectedGenres = []
    this.genreTargets.forEach(button => {
      button.classList.remove('bg-indigo-500', 'text-white')
      button.classList.add('bg-neutral-700')
    })
    this.filter()
  }

  filter() {
    const url = new URL(window.location.origin + '/filter_albums')
    
    if (this.selectedGenres.length > 0) {
      url.searchParams.set('genres', this.selectedGenres.join(','))
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    
    fetch(url.toString(), {
      method: 'POST',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': csrfToken
      }
    })
  }
} 