import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["genre"]
  static values = {
    selected: Array
  }

  connect() {
    this.selectedValue = []
    this.restoreStateFromUrl()
  }

  restoreStateFromUrl() {
    const url = new URL(window.location)
    const genres = url.searchParams.get('genres')
    
    if (genres) {
      this.selectedValue = genres.split(',')
      this.genreTargets.forEach(button => {
        const genreId = button.dataset.genreId
        if (this.selectedValue.includes(genreId)) {
          button.classList.remove('bg-neutral-700')
          button.classList.add('bg-indigo-500', 'text-white')
        }
      })
    }
  }

  toggle(event) {
    const genreId = event.currentTarget.dataset.genreId
    const button = event.currentTarget
    
    if (this.selectedValue.includes(genreId)) {
      this.selectedValue = this.selectedValue.filter(id => id !== genreId)
      button.classList.remove('bg-indigo-500', 'text-white')
      button.classList.add('bg-neutral-700')
    } else {
      this.selectedValue.push(genreId)
      button.classList.remove('bg-neutral-700')
      button.classList.add('bg-indigo-500', 'text-white')
    }

    this.filter()
  }

  clearAll() {
    this.selectedValue = []
    this.genreTargets.forEach(button => {
      button.classList.remove('bg-indigo-500', 'text-white')
      button.classList.add('bg-neutral-700')
    })
    this.filter()
  }

  filter() {
    const url = new URL(window.location.origin + '/filter_albums')
    if (this.selectedValue.length > 0) {
      url.searchParams.set('genres', this.selectedValue.join(','))
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