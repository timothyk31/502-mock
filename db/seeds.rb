# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.development?
    speakers = Speaker.create([
        { name: "John Doe", details: "Expert in Ruby on Rails", email: "john.doe@example.com" },
        { name: "Jane Smith", details: "JavaScript enthusiast", email: "jane.smith@example.com" },
        { name: "Alice Johnson", details: "Specialist in Machine Learning", email: "alice.johnson@example.com" }
    ])
end