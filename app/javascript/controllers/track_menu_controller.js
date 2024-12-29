import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  static values = {
    trackId: String
  }

  connect() {
    document.addEventListener('click', this.closeMenu.bind(this))
    document.addEventListener('close-all-menus', this.closeMenu.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeMenu.bind(this))
    document.removeEventListener('close-all-menus', this.closeMenu.bind(this))
  }

  toggle(event) {
    event.stopPropagation()
    
    document.dispatchEvent(new CustomEvent('close-all-menus'))
    
    const isHidden = this.menuTarget.classList.contains('hidden')
    if (isHidden) {
      this.menuTarget.classList.remove('hidden')
    } else {
      this.menuTarget.classList.add('hidden')
    }
  }

  closeMenu(event) {
    if (!this.element.contains(event.target) || event instanceof CustomEvent) {
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
} 