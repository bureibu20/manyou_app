# User.create!(name: "kenya", email: "kenya@gmail.com", password: "123456", password_confirmation: "123456", admin: true)

9.times do |n|
  name = Faker::Games::Pokemon.name
  email = Faker::Internet.email
  password = "1111111"
  password_confirmation = "1111111"
  User.create!(name: name, email: email, password: password, password_confirmation: password_confirmation, admin: false)
end