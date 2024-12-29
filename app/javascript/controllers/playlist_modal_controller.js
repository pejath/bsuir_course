import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    trackId: String
  }

  connect() {
    // Слушаем событие открытия модального окна
    window.addEventListener('open-playlist-modal', this.handleOpen.bind(this))
    
    // Закрытие по клику вне модального окна
    this.element.addEventListener('click', (e) => {
      if (e.target === this.element) {
        this.close()
      }
    })

    // Закрытие по Escape
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') this.close()
    })
  }

  disconnect() {
    window.removeEventListener('open-playlist-modal', this.handleOpen.bind(this))
  }

  handleOpen(event) {
    this.trackIdValue = event.detail.trackId
    this.element.classList.remove('hidden')
  }

  close() {
    this.element.classList.add('hidden')
  }

  async addToPlaylist(event) {
    const playlistId = event.currentTarget.dataset.playlistId
    
    try {
      const response = await fetch(`/playlists/${playlistId}/add_track`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          track_id: this.trackIdValue
        })
      })

      if (response.ok) {
        const data = await response.json()
        // Добавим уведомление об успехе
        const notification = document.createElement('div')
        notification.className = 'fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
        notification.textContent = data.message
        document.body.appendChild(notification)
        
        setTimeout(() => {
          notification.remove()
        }, 3000)
        
        this.close()
      } else {
        throw new Error('Failed to add track to playlist')
      }
    } catch (error) {
      console.error('Error:', error)
      // Показываем уведомление об ошибке
      const notification = document.createElement('div')
      notification.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
      notification.textContent = 'Failed to add track to playlist'
      document.body.appendChild(notification)
      
      setTimeout(() => {
        notification.remove()
      }, 3000)
    }
  }
} 