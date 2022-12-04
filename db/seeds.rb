# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: "get.dipen@gmail.com", first_name: "Dipen", last_name: "Chauhan", login: "helloworld")

Category.create(name: "Hidden", abbr: "Hidden")
Category.create(name: "Ruby on Rails", abbr: "RoR")
Category.create(name: "JavaScript", abbr: "JS")
Category.create(name: "C++", abbr: "C++")
