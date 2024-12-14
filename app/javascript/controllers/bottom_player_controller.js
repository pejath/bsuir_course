import { Controller } from "@hotwired/stimulus"
import Plyr from "plyr"

export default class extends Controller {
  static targets = ["player"]
  static values = {
    tracks: Array,
    currentTrackIndex: Number
  }

  connect() {
    console.log("Bottom player controller connected")
    if (this.element.id === 'player-bar' && this.hasPlayerTarget) {
      this.initializePlayer()
    }
  }

  initializePlayer() {
    console.log("Initializing Plyr...")
    this.player = new Plyr(this.playerTarget, {
      controls: ['play-large', 'play', 'progress', 'current-time', 'duration', 'mute', 'volume']
    })

    this.player.on('ended', () => {
      this.playNextTrack()
    })

    document.getElementById('prev-track')?.addEventListener('click', () => this.playPreviousTrack())
    document.getElementById('next-track')?.addEventListener('click', () => this.playNextTrack())
  }

  playTrack(event) {
    event.preventDefault()
    
    const playerBar = document.getElementById('player-bar')
    const playerController = this.application.getControllerForElementAndIdentifier(playerBar, 'bottom-player')
    
    if (!playerController || !playerController.player) {
      console.error('Player controller not found')
      return
    }

    const trackData = {
      url: event.currentTarget.dataset.trackUrl,
      title: event.currentTarget.dataset.trackTitle,
      index: parseInt(event.currentTarget.dataset.trackIndex),
      cover: event.currentTarget.dataset.albumCover,
      artist: event.currentTarget.dataset.artistName
    }

    console.log("Playing track:", trackData)
    
    playerController.updatePlayerUI(trackData)
    playerController.updateAudioSource(trackData)
  }

  updatePlayerUI(trackData) {
    const playerBar = document.getElementById('player-bar')
    playerBar.classList.remove('hidden')
    
    document.getElementById('player-track-name').textContent = trackData.title
    document.getElementById('player-artist-name').textContent = trackData.artist
    document.getElementById('player-cover-image').innerHTML = `
      <img src="${trackData.cover}" class="w-full h-full object-cover" alt="${trackData.title}">
    `
    
    this.currentTrackIndexValue = trackData.index
  }

  updateAudioSource(trackData) {
    if (this.player) {
      this.player.source = {
        type: 'audio',
        sources: [
          {
            src: trackData.url,
            type: 'audio/mp3'
          }
        ]
      }
      this.player.play()
    } else {
      console.error('Player not initialized')
    }
  }

  playNextTrack() {
    console.log("Playing next track")
    if (!this.hasTracksValue) {
      console.log("No tracks available")
      return
    }
    
    const nextIndex = (this.currentTrackIndexValue + 1) % this.tracksValue.length
    const nextTrack = this.tracksValue[nextIndex]
    
    console.log("Next track:", nextTrack)
    this.updatePlayerUI(nextTrack)
    this.updateAudioSource(nextTrack)
  }

  playPreviousTrack() {
    console.log("Playing previous track")
    if (!this.hasTracksValue) {
      console.log("No tracks available")
      return
    }
    
    let prevIndex = this.currentTrackIndexValue - 1
    if (prevIndex < 0) prevIndex = this.tracksValue.length - 1
    
    const prevTrack = this.tracksValue[prevIndex]
    
    console.log("Previous track:", prevTrack)
    this.updatePlayerUI(prevTrack)
    this.updateAudioSource(prevTrack)
  }
} 