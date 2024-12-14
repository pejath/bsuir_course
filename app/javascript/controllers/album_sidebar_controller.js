import { Controller } from "@hotwired/stimulus"
import Plyr from "plyr"

export default class extends Controller {
  static targets = ["player"]

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
    console.log("showDetails called")
    const albumId = event.currentTarget.dataset.albumId
    const sidebar = document.getElementById('album-sidebar')
      
    sidebar.classList.remove('hidden')

    fetch(`/albums/${albumId}/sidebar_info`)
      .then(response => response.json())
      .then(data => {
        this.updateSidebar(data)
      })
  }

  updateSidebar(data) {
    console.log("updateSidebar called, player:", this.player)
    document.getElementById('sidebar-cover-image').innerHTML = `
      <img src="${data.cover_url}" class="w-full h-full object-cover" alt="${data.title}">
    `
    document.getElementById('sidebar-album-title').textContent = data.title
    document.getElementById('sidebar-artist-name').textContent = data.artist_name
    document.getElementById('sidebar-track-name').textContent = data.sample_track_name
    
    if (this.player) {
      console.log("Updating player source")
      this.player.source = {
        type: 'audio',
        sources: [
          {
            src: "http://localhost:3000"+data.audio_file_url,
            type: 'audio/mp3'
          }
        ]
      }
      this.player.restart()
    } else {
      console.error("Player not found in updateSidebar")
    }
  }
} 