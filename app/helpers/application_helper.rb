module ApplicationHelper

  def get_direction
    request.fullpath.include?('direction=asc') ? 'desc' : 'asc'
  end

  def get_direction_sign(direction)
    direction == 'asc' ? '▲' : '▼'
  end
end
