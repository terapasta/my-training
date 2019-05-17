module LinksAreaHelper

  def is_action_name?(*names)
    names_include_name?(names, action_name)
  end

  def is_controller_name?(*names)
    names_include_name?(names, controller_name)
  end

  def names_include_name?(names, name)
    names.each do |e|
      return true if name == e
    end
    false
  end

  def create_prefix
    "#{'admin/' if controller_name == 'users'}#{controller_name}"
  end

  def show_task_item?(user, task_id)
    is_controller_name?('tasks') && user.user_task_debtee?(task_id)
  end

  def get_link(prefix, action, group_id: group_id, task_id: task_id, user_id: user_id)
    render "#{prefix}/shared/links/#{action}", group_id: group_id, task_id: task_id, user_id: user_id
  end
end
