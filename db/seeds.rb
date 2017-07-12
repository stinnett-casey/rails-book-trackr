# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
file = File.read('public/books-to-read.json')
book_hash = JSON.parse file
tables = book_hash['books'].each do |book|
  Book.create(sku: book[0], title: book[1], category: book[2], author: book[3])
end
