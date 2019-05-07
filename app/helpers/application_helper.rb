module ApplicationHelper

  def sorted?
    q = request.query_parameters
    q.include?('direction') && q.include?('sort')
  end

  def sorted_col?(col_name)
    q = request.query_parameters
    q.include?('sort') && q[:sort].include?(col_name)
  end

  def get_direction
    if sorted?
      request.query_parameters[:direction] == 'asc' ? 'desc' : 'asc'
    else
      'desc'
    end
  end

  def get_direction_sign(col_name, direction)
    if sorted? && sorted_col?(col_name)
      direction == 'desc' ? '▲' : '▼'
    else
      ''
    end
  end
end
