# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

group1 = Group.create(name: 'group1')
group2 = Group.create(name: 'group2')

10.times do |i| 
  if i < 5
    user = User.create(name: "ユーザー#{i}", email: "email#{i}@sample.com", password: "password01", role: 'normal')
    UserGroup.create(user_id: user.id, group_id: group1.id)
  else
    user = User.create(name: "ユーザー#{i}", email: "email#{i}@sample.com", password: "password01", role: 'admin')
    UserGroup.create(user_id: user.id, group_id: group2.id)
  end
end

20.times do |i|
  user = ''
  if i < 4
    user = User.first
  elsif i >= 4 && i < 8
    user = User.second
  elsif i >=8 && i < 12
    user = User.third
  elsif i >=12 && i < 16
    user = User.fourth
  else
    user = User.fifth
  end
  group = user.groups.first
  task = Task.create(name: "task#{i}", description: "description#{i}description#{i}description#{i}description#{i}", 
    priority: 'middle', deadline: Time.zone.today.since(1.week) + i.day, status: 'waiting', group_id: group.id)
  group.users.each do |g_user|
    task_role = (g_user == user) ? 'debtee' : 'debtor'
    g_user.user_tasks.create(task_id: task.id, task_role: task_role)
  end
end
