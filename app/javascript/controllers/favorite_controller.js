import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    albumId: String,
    state: Boolean
  }

  async toggle() {
    const method = this.stateValue ? 'DELETE' : 'POST'
    const url = this.stateValue ? '/favorites/destroy' : '/favorites'
    
    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          album_id: this.albumIdValue
        })
      })

      if (response.ok) {
        const data = await response.json()
        
        // Обновляем состояние и внешний вид кнопки
        this.stateValue = !this.stateValue
        const icon = this.element.querySelector('i')
        const text = this.element.querySelector('span')
        
        if (this.stateValue) {
          icon.classList.remove('fa-heart-o')
          icon.classList.add('fa-heart', 'text-red-500')
          text.textContent = 'Remove from Favorites'
        } else {
          icon.classList.remove('fa-heart', 'text-red-500')
          icon.classList.add('fa-heart-o')
          text.textContent = 'Add to Favorites'
        }
        
        // Показываем уведомление
        const notification = document.createElement('div')
        notification.className = 'fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
        notification.textContent = data.message
        document.body.appendChild(notification)
        
        setTimeout(() => {
          notification.remove()
        }, 3000)
      } else {
        throw new Error('Failed to update favorites')
      }
    } catch (error) {
      console.error('Error:', error)
      const notification = document.createElement('div')
      notification.className = 'fixed top-4 right-4 bg-red-500 text-white px-4 py-2 rounded-lg shadow-lg z-50'
      notification.textContent = error.message
      document.body.appendChild(notification)
      
      setTimeout(() => {
        notification.remove()
      }, 3000)
    }
  }
} 