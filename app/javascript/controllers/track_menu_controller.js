import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  static values = {
    trackId: String
  }

  connect() {
    document.addEventListener('click', this.closeMenu.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeMenu.bind(this))
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle('hidden')
  }

  closeMenu(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
    }
  }

  addToPlaylist(event) {
    event.preventDefault()
    this.menuTarget.classList.add('hidden')
    
    const customEvent = new CustomEvent('open-playlist-modal', {
      detail: { trackId: this.trackIdValue }
    })
    window.dispatchEvent(customEvent)
  }

  async removeFromPlaylist(event) {
    event.preventDefault()
    const playlistId = event.currentTarget.dataset.playlistId
    
    try {
      const response = await fetch(`/playlists/${playlistId}/remove_track`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          track_id: this.trackIdValue
        })
      })

      const data = await response.json()
      
      if (response.ok) {
        // Удаляем трек из DOM
        this.element.closest('.group').remove()
        
        // Показываем уведомление
        const notification = document.createElement('div')
        notification.className = 'fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
        notification.textContent = data.message
        document.body.appendChild(notification)
        
        setTimeout(() => {
          notification.remove()
        }, 3000)
      } else {
        throw new Error(data.error)
      }
    } catch (error) {
      console.error('Error:', error)
      // Показываем уведомление об ошибке
      const notification = document.createElement('div')
      notification.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
      notification.textContent = error.message || 'Failed to remove track from playlist'
      document.body.appendChild(notification)
      
      setTimeout(() => {
        notification.remove()
      }, 3000)
    }
    
    this.menuTarget.classList.add('hidden')
  }
} 