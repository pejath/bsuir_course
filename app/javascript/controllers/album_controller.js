import { Controller } from "@hotwired/stimulus"
import Plyr from "plyr"

export default class extends Controller {
  static targets = ["player"]
  static values = {
    tracks: Array,
    currentTrackIndex: Number
  }

  initialize() {
    this.player = null
  }

  connect() {
    if (this.hasPlayerTarget) {
      console.log("Initializing Plyr in player bar...")
      this.player = new Plyr(this.playerTarget, {
        controls: ['play-large', 'play', 'progress', 'current-time', 'duration', 'mute', 'volume']
      })

      this.player.on('ended', () => {
        this.playNextTrack()
      })

      document.getElementById('prev-track')?.addEventListener('click', () => this.playPreviousTrack())
      document.getElementById('next-track')?.addEventListener('click', () => this.playNextTrack())
    }
  }

  playTrack(event) {
    event.preventDefault()
    const trackUrl = event.currentTarget.dataset.trackUrl
    const trackTitle = event.currentTarget.dataset.trackTitle
    const trackIndex = parseInt(event.currentTarget.dataset.trackIndex)
    const albumCover = event.currentTarget.dataset.albumCover
    const artistName = event.currentTarget.dataset.artistName
    
    console.log("Playing track:", { trackUrl, trackTitle, trackIndex, albumCover, artistName })
    
    const playerBarController = this.application.getControllerForElementAndIdentifier(
      document.querySelector('.container[data-controller="album"]'),
      'album'
    )
    
    if (!playerBarController || !playerBarController.player) {
      console.error('Player controller not found:', { 
        controller: playerBarController, 
        player: playerBarController?.player 
      })
      return
    }
    
    const playerBar = document.getElementById('player-bar')
    playerBar.classList.remove('hidden')
    
    document.getElementById('player-track-name').textContent = trackTitle
    document.getElementById('player-artist-name').textContent = artistName
    document.getElementById('player-cover-image').innerHTML = `
      <img src="${albumCover}" class="w-full h-full object-cover" alt="${trackTitle}">
    `
    
    this.currentTrackIndexValue = trackIndex
    
    playerBarController.player.source = {
      type: 'audio',
      sources: [{ src: trackUrl, type: 'audio/mp3' }]
    }
    
    playerBarController.player.play()
  }

  playNextTrack() {
    const nextIndex = (this.currentTrackIndexValue + 1) % this.tracksValue.length
    const nextTrack = this.tracksValue[nextIndex]
    
    const trackButton = document.querySelector(`[data-track-index="${nextIndex}"]`)
    if (trackButton) {
      trackButton.click()
    }
  }

  playPreviousTrack() {
    let prevIndex = this.currentTrackIndexValue - 1
    if (prevIndex < 0) prevIndex = this.tracksValue.length - 1
    
    const trackButton = document.querySelector(`[data-track-index="${prevIndex}"]`)
    if (trackButton) {
      trackButton.click()
    }
  }
} 