# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Удаляем существующие данные перед добавлением новых
require 'mediainfo'
require 'rexml/document'

Genre.destroy_all
Playlist.destroy_all
Track.destroy_all
Review.destroy_all
Album.destroy_all
Subscription.destroy_all
Artist.destroy_all
Favorite.destroy_all
Tag.destroy_all
User.destroy_all
AdminUser.destroy_all
AdminUser.create!(email: 'admin@band.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

def fetch_random_image
  url = URI('https://api.api-ninjas.com/v1/randomimage')
  params = { height: 500, width: 500, category: "city" }
  url.query = URI.encode_www_form(params)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['X-Api-Key'] = 'TQ23c1D+eR//rgQMdbCtkw==tF8FmAMf0dOvrs3i'  # Замените на ваш API ключ
  request['Accept'] = 'image/jpg'

  response = http.request(request)
  
  if response.code == '200'
    return response.body
  else
    puts "Error fetching image: #{response.code} #{response.message}"
    return nil
  end
end

# Создаем пользователей
puts 'Creating users...'
users = []
u = User.create!(email: 'pejath@yandex.ru',username: 'pejath', password: 'password')

if image_data = fetch_random_image
  u.avatar.attach(
    io: StringIO.new(image_data),
    filename: "#{u.username}_avatar.jpg",
    content_type: 'image/jpeg'
  )
end

5.times do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    username: "user_#{i + 1}",
  )

  if image_data = fetch_random_image
    user.avatar.attach(
      io: StringIO.new(image_data),
      filename: "user_#{i + 1}_avatar.jpg",
      content_type: 'image/jpeg'
    )
  end
  users << user
end

# Создаем жанры
puts 'Creating genres...'
genres = []
5.times do
  genres << Genre.create!(
    name: Faker::Music.unique.genre,
    description: Faker::Lorem.sentence(word_count: 10)
  )
end

# Создаем артистов
puts 'Creating artists...'
artists = []
users.each do |user|
  artists << Artist.create!(
    user: user,
    name: Faker::Music.band,
    bio: Faker::Lorem.paragraph,
    profile_img: Faker::Avatar.image
  )
end
# Создаем теги
puts 'Creating tags...'
tags = []
tags = 12.times.map do
  tags << Tag.create!(name: Faker::Music.unique.genre)
end

# Создаем альбомы
puts 'Creating albums...'
albums = artists.flat_map do |artist|
  3.times.map do
    album = Album.create!(
      artist: artist,
      title: Faker::Music.album,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      release_date: Faker::Date.between(from: 10.years.ago, to: Date.today)
    )

    album.tags << tags.sample(1)

    if image_data = fetch_random_image
      album.cover_image.attach(
        io: StringIO.new(image_data),
        filename: "album_#{album.id}_cover.jpg",
        content_type: 'image/jpeg'
      )
    end

    album
  end
end

# Создаем треки
puts 'Creating tracks...'
tracks = []
audio_files = Dir[Rails.root.join('db/seeds/audio/*.mp3')]

albums.each do |album|
  4.times do |index|
    audio_file = audio_files.pop
    next unless audio_file

    media_info = MediaInfo.from(audio_file)
    duration = media_info.audio.duration.to_i / 1000

    track = Track.create!(
      album: album,
      title: media_info.general.title,
      duration: duration, 
      price: rand(0..10).round(2),
      play_count: rand(0..1000)
    )
    tracks << track

    track.audio_file.attach(
      io: File.open(audio_file),
      filename: File.basename(audio_file),
      content_type: 'audio/mpeg'
    )

    track.tags << album.tags
  end
end

# Создаем плейлисты
puts 'Creating playlists...'
users.each do |user|
  2.times do
    playlist = Playlist.create!(
      user: user,
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 3)
    )
    playlist.tracks << tracks.sample(rand(5..10))
  end
end

# Создаем отзывы
puts 'Creating reviews...'
albums.each do |album|
  rand(1..3).times do
    Review.create!(
      user: users.sample,
      album: album,
      rating: rand(1..5),
      comment: Faker::Lorem.paragraph
    )
  end
end

# Создаем избранное
puts 'Creating favorites...'
users.each do |user|
  Favorite.create!(user: user, favoritable: albums.sample)
  Favorite.create!(user: user, favoritable: tracks.sample)
end

# Связываем теги с треками
puts 'Tagging tracks...'
tracks.each do |track|
  track.tags << tags.sample(1)
end

# Создаем подписки
puts 'Creating subscriptions...'
users.each do |user|
  artists.sample(rand(1..3)).each do |artist|
    Subscription.create!(user: user, artist: artist)
  end
end

puts 'Seeding completed!'
