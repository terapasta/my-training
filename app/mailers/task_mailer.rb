class TaskMailer < ApplicationMailer
  add_template_helper(TasksHelper)

  def remind_task(user, task)
    @user = user
    @task = task

    mail(
      from: 'toritate@example.com',
      to:   @user.email,
      subject: "【#{@task.name}】を確認してください！！"
    )
  end
end
