# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Удаляем существующие данные перед добавлением новых
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

# Создаем пользователей
puts 'Creating users...'
users = []
User.create!(email: 'pejath@yandex.ru', password: 'password')
5.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    # username: Faker::Internet.username,
    # role: %w[user artist].sample
  )
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

# Создаем альбомы
puts 'Creating albums...'
albums = []
artists.each do |artist|
  3.times do
    albums << Album.create!(
      artist: artist,
      title: Faker::Music.album,
      description: Faker::Lorem.paragraph,
      release_date: Faker::Date.backward(days: 1000),
      cover_image: nil # Можно загрузить случайную картинку позже через ActiveStorage
    )
  end
end

# Создаем треки
puts 'Creating tracks...'
tracks = []
albums.each do |album|
  5.times do |index|
    track = Track.create!(
      album: album,
      title: "Track #{index + 1} - #{album.title}",
      duration: rand(120..300), # Длительность в секундах
      price: rand(0..10).round(2),
      play_count: rand(0..1000)
    )
    tracks << track

    # Добавляем трек к случайным жанрам
    track.genres << genres.sample(rand(1..3))
  end
end

# Создаем плейлисты
puts 'Creating playlists...'
users.each do |user|
  2.times do
    playlist = Playlist.create!(
      user: user,
      title: Faker::Lorem.sentence(word_count: 3)
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

# Создаем теги
puts 'Creating tags...'
tags = []
5.times do
  tags << Tag.create!(name: Faker::Lorem.word)
end

# Связываем теги с треками
puts 'Tagging tracks...'
tracks.each do |track|
  track.tags << tags.sample(rand(1..3))
end

# Создаем подписки
puts 'Creating subscriptions...'
users.each do |user|
  artists.sample(rand(1..3)).each do |artist|
    Subscription.create!(user: user, artist: artist)
  end
end

puts 'Seeding completed!'
