module LinksAreaHelper

  def render_from_this_action?(*names)
    names.include?(action_name)
  end

  def render_from_this_controller?(*names)
    names.include?(controller_name)
  end

  def create_prefix
    "#{'admin/' if controller_name == 'users'}#{controller_name}"
  end

  def show_task_item?(user, task_id)
    render_from_this_controller?('tasks') && user.user_task_debtee?(task_id)
  end

  def get_link(prefix, action, group_id: group_id, task_id: task_id, user_id: user_id)
    render "#{prefix}/shared/links/#{action}", group_id: group_id, task_id: task_id, user_id: user_id
  end
end
