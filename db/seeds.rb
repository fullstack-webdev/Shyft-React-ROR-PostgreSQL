# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  full_name = first_name + " " + last_name
  email = "staging+" + n.to_s + "@shyftworks.com"
  about = Faker::Lorem.paragraphs(4, true)
  password = "test1235"
  phone = Faker::Number.number(10)
  rate = Faker::Number.between(12, 24)
  Ambassador.create!(
    first_name: first_name,
    last_name: last_name,
    full_name: full_name,
    email: email,
    about: about,
    phone_number: phone,
    rate_currency: "CAD",
    rate: rate,
    city: "Toronto",
    state: "Ontario",
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now,
    email_confirmed: true)
end
ambassadors = Ambassador.all
  ambassadors.each { |ambassador|
  start_time = nil
  end_time = nil
  ambassador.weekly_unavailability = WeeklyUnavailability.create!(
    sunday_start: start_time,
    sunday_end: end_time,
    monday_start: start_time,
    monday_end: end_time,
    tuesday_start: start_time,
    tuesday_end: end_time,
    wednesday_start: start_time,
    wednesday_end: end_time,
    thursday_start: start_time,
    thursday_end: end_time,
    friday_start: start_time,
    friday_end: end_time,
    saturday_start: start_time,
    saturday_end: end_time)
  Review.create!(
  content: "Donec ac nibh pretium libero ornare molestie. Sed eleifend nunc nec nulla volutpat blandit. Ut at eros quis purus faucibus dignissim. Nam eros est, gravida id lorem tincidunt, malesuada feugiat massa.",
  name: "Martin Gooding",
  rating: 5.0,
  email: "martin@gooding.com",
  ambassador_id:ambassador.id)
  AmbassadorRole.create!(
  ambassador_id:ambassador.id,
  role_type_id:Faker::Number.between(1, 2)
  )
  AmbassadorRole.create!(
  ambassador_id:ambassador.id,
  role_type_id:Faker::Number.between(3, 5)
  )
}
Agency.create!(
  email: "partybus@agency.com",
  phone_number: "6444338888",
  city: "toronto",
  state: "Ontario",
  address1: "22230 party street",
  company_name: "Party Bus",
  activated: true,
  first_name: "Sarah",
  last_name: "Space",
  password: "test1235",
  password_confirmation: "test1235")
AdminUser.create!(email: "admin@example.com", password: "test1235", password_confirmation: "test1235")
RoleStatus.create!(status:"empty", displayname: "None")
RoleStatus.create!(status:"short-list", displayname: "Short List")
RoleStatus.create!(status:"pending", displayname: "Pending")
RoleStatus.create!(status:"confirmed", displayname: "Confirmed")
RoleStatus.create!(status:"declined", displayname: "Declined")
RoleStatus.create!(status:"expired", displayname: "Expired")
RoleStatus.create!(status:"cancelled", displayname: "Cancelled")
RoleType.create!(type_of: "brand-ambassador", displayname: "Ambassador", abbrv: "A")
RoleType.create!(type_of: "food-sampler", displayname: "Sampler", abbrv: "S")
RoleType.create!(type_of: "team-lead", displayname: "Team Lead", abbrv: "T")
RoleType.create!(type_of: "bartender", displayname: "Bartender", abbrv: "B")
RoleType.create!(type_of: "promo-model", displayname: "Promo Model", abbrv: "P")
