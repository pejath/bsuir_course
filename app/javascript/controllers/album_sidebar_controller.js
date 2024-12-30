import { Controller } from "@hotwired/stimulus"
import Plyr from "plyr"

export default class extends Controller {
  static targets = ["player", "favoriteButton"]

  connect() {
    console.log("Sidebar controller connected")
    if (this.hasPlayerTarget) {
      console.log("Player target found, initializing Plyr...")
      this.player = new Plyr(this.playerTarget, {
        controls: ['play', 'progress', 'current-time', 'volume']
      })
      console.log("Plyr initialized:", this.player)
    } else {
      console.log("Player target not found")
    }
  }

  showDetails(event) {
    event.preventDefault()
    const albumId = event.currentTarget.dataset.albumId

    fetch(`/albums/${albumId}/sidebar_info`)
      .then(response => response.json())
      .then(data => {
        // Обновляем данные кнопки избранного
        this.favoriteButtonTarget.dataset.favoriteAlbumIdValue = albumId
        this.favoriteButtonTarget.dataset.favoriteStateValue = data.is_favorited

        // Обновляем внешний вид кнопки
        const icon = this.favoriteButtonTarget.querySelector('i')
        const text = this.favoriteButtonTarget.querySelector('span')
        
        if (data.is_favorited) {
          icon.classList.remove('fa-heart-o')
          icon.classList.add('fa-heart', 'text-red-500')
          text.textContent = 'Remove from Favorites'
        } else {
          icon.classList.remove('fa-heart', 'text-red-500')
          icon.classList.add('fa-heart-o')
          text.textContent = 'Add to Favorites'
        }

        // Обновляем остальные элементы сайдбара
        document.getElementById('sidebar-album-title').textContent = data.title
        document.getElementById('sidebar-artist-name').textContent = data.artist_name
        document.getElementById('sidebar-track-name').textContent = data.sample_track_name
        
        const coverImage = document.getElementById('sidebar-cover-image')
        coverImage.style.backgroundImage = `url('${data.cover_url}')`
        coverImage.style.backgroundSize = 'cover'
        coverImage.style.backgroundPosition = 'center'

        if (data.audio_file_url) {
          const audioSource = document.getElementById('audio-source')
          audioSource.src = data.audio_file_url
          this.playerTarget.load()
        }

        // Показываем сайдбар
        document.getElementById('album-sidebar').classList.remove('hidden')
      })
  }
} 