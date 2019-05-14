module TasksHelper

  def link_to_sort_tasks(title, col_name)
    direction = get_direction
    link_to "#{get_direction_sign(col_name, direction)}#{title}", 
            tasks_path(sort: col_name, direction: direction), data: {"turbolinks" => false}
  end

  def array_with_blank(name, array)
    array.unshift([name, ''])
  end

  def get_notice_type(deadline)
    diff = get_diff_from_today(deadline)
    if diff < 0
      'danger'
    elsif diff == 0
      'warning'
    elsif 0 < diff && diff <= 3
      'info'
    end
  end

  def get_notice_message(name, type, days)
    if type == 'info'
      "#{t('messages.notification.info', task_name: name, days: days)}"
    else
      "#{t("messages.notification.#{type}", task_name: name)}"
    end
  end

  def is_info?(deadline)
    diff = get_diff_from_today(deadline)
    0 < diff && diff <= 3
  end
end
