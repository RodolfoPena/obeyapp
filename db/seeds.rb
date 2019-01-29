# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
include CommitmentsHelper

Task.all.destroy_all
Member.destroy_all
Team.destroy_all
Commitment.destroy_all
Target.destroy_all
User.destroy_all

10.times do |i|
    i += 1
  user = User.new(
    id: i,
    email: "user#{i}@mail.com",
    password: '112233',
    password_confirmation: '112233',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    bio: Faker::GreekPhilosophers.quote
  )
  user.avatar.attach(io: File.open("vendor/images/avatar#{i}.jpg"), filename: "avatar#{i}.jpg")
  user.skip_confirmation!
  user.save!
end

# Max 3 teams by coach with max 5 coaches
5.times do
  user_ids = User.ids
  max_teams = 1 + rand(3)
  (1 + rand(4)).times do
    Team.create(
      name: Faker::Job.field,
      description: Faker::Company.catch_phrase,
      user: User.find(user_ids.sample)
    )
  end
end

members = []
# Max 10 members by team
Team.all.each do |team|
  team = team
  members_length = 3 + rand(8)
  members_length.times do
    user_ids = User.ids
    user = User.find(user_ids.sample)
    member = Member.find_by(user_id: user.id, team_id: team.id)
    if member.nil?
      if members.exclude?(member)
        Member.create(
        user: user,
        team: team
        )
      end
        members << user
    end
  end
end



# Max 4 targets by team
Team.all.each do |team|
  team = team
  user_ids = team.user_members.ids
  (1 + rand(4)).times do
    values = [Faker::Number.number(2) + "% ", ""]
    user = User.find(user_ids.sample)
    responsible = User.find(user_ids.sample)
    start_date = Faker::Date.between(Date.today.beginning_of_year, Date.today.end_of_year)
    due_date = Faker::Date.between(start_date, start_date + rand(180).days)
     Target.create(
       user: user,
       team: team,
       responsible: responsible,
       title: values[rand(1)] + Faker::Company.bs,
       description: Faker::Company.buzzword,
       start_date: start_date,
       due_date: due_date
      )
  end
end

Target.all.each do |target|
  target = target
  (5 + rand(20)).times do
    action = Faker::Company.bs
    conditions_of_satisfaction =  Faker::Company.catch_phrase
    start_date =  Faker::Date.between(target.start_date, target.due_date)
    due_date = Faker::Date.between(start_date, target.due_date) if Faker::Boolean.boolean(0.5)
    renegotiation_date = Faker::Date.between(due_date, target.due_date) if Faker::Boolean.boolean(0.5) && (due_date.nil? == false)
    if renegotiation_date.nil?
      closing_date = Faker::Date.between(start_date, target.due_date) if Faker::Boolean.boolean(0.5)
    else
      closing_date = Faker::Date.between(renegotiation_date, target.due_date) if Faker::Boolean.boolean(0.5)
    end
    members_length = Team.find(target.team_id).user_members.length
    commitment = Commitment.new(
      action: action,
      conditions_of_satisfaction: conditions_of_satisfaction,
      start_date: start_date,
      due_date: due_date,
      renegotiation_date: renegotiation_date,
      closing_date: closing_date,
      critical: Faker::Boolean.boolean(0.5),
      deliverable: Faker::Boolean.boolean(0.5),
      user: Team.find(target.team_id).user_members[rand(members_length)],
      target: target,
      responsible: Team.find(target.team_id).user_members[rand(members_length)],
    )
    set_status(commitment)
    commitment.save!
  end
end

Commitment.all.each do |commitment|
  (1 + rand(5)).times do
    Task.create(
      commitment: commitment,
      name: Faker::Company.bs.capitalize,
      done: Faker::Boolean.boolean(0.5)
    )
  end
end
