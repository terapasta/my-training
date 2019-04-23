module TasksHelper

  def link_to_sort_tasks(title, col_name)
    direction = get_direction
    link_to "#{get_direction_sign(direction)}#{title}", 
            tasks_path(sort: col_name, direction: direction), data: {"turbolinks" => false}
  end
end
