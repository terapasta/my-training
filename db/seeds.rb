# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |i| 
  if i < 5
    User.create(name: "ユーザー#{i}", email: "email#{i}@sample.com", password: "password01", role: 'normal')
  else
    User.create(name: "ユーザー#{i}", email: "email#{i}@sample.com", password: "password01", role: 'admin')
  end
end

20.times do |i|
  user_id = ''
  if i < 4
    user_id = User.first.id
  elsif i >= 4 && i < 8
    user_id = User.second.id
  elsif i >=8 && i < 12
    user_id = User.third.id
  elsif i >=12 && i < 16
    user_id = User.fourth.id
  else
    user_id = User.fifth.id
  end
  Task.create(name: "task#{i}", description: "description#{i}description#{i}description#{i}description#{i}", 
    priority: 'middle', deadline: Date.today.since(1.week) + i.day, status: 'waiting', user_id: user_id)
end

5.times { |i| Label.create(name: "label#{i}") }

Task.first(5).each_with_index do |task, i|
  TaskLabel.create(task_id: task.id, label_id: Label.find_by(name: "label#{i}").id)
end
