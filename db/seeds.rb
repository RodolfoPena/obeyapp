# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Member.destroy_all
User.destroy_all
Team.destroy_all
Target.destroy_all
Commitment.destroy_all


first_names = ["Jhon", ""]
10.times do |i|
  i = i + 1
  user = User.new(email: "user#{i}@mail.com",
                  password: '123456',
                  password_confirmation: '123456',
                  first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  bio: Faker::GreekPhilosophers.quote
                )
  user.avatar.attach(io: File.open("vendor/images/avatar#{i}.jpg"), filename: "avatar#{i}.jpg")
  user.skip_confirmation!
  user.save!
end
