import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Dropdown controller connected")
    document.addEventListener('click', this.closeMenu.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeMenu.bind(this))
  }

  toggle(event) {
    event.stopPropagation()
    console.log("Toggle clicked")
    this.menuTarget.classList.toggle('hidden')
  }

  closeMenu(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
    }
  }
} 