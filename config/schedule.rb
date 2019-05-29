require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, 'log/cron.log'

every 1.day, at: '8:00 am' do
  rake 'mailers:remind_tasks_deadline'
end
