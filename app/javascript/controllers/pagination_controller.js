import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["container", "loadMoreButton"]
  
  connect() {
    console.log("Pagination controller connected", this.element)
    this.page = 1
    this.loading = false
  }

  loadMore(event) {
    event.preventDefault()
    event.stopPropagation()
    
    if (this.loading) return
    this.loading = true
    
    this.page += 1
    const url = new URL(window.location.origin + '/filter_albums')
    url.searchParams.set('page', this.page)
    
    const currentGenres = new URL(window.location).searchParams.get('genres')
    if (currentGenres) {
      url.searchParams.set('genres', currentGenres)
    }

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    
    fetch(url.toString(), {
      method: 'POST',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': csrfToken
      }
    })
    .then(response => response.text())
    .then(html => {
      const template = document.createElement('template')
      template.innerHTML = html
      const turboStream = template.content.firstElementChild
      
      if (turboStream.getAttribute('action') === 'append') {
        const content = turboStream.querySelector('template').content.cloneNode(true)
        this.containerTarget.appendChild(content)
      }
    })
    .finally(() => {
      this.loading = false
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }
} 
