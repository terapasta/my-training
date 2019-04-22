module ApplicationHelper

  def sorted?
    request.fullpath.include?('direction')
  end

  def get_direction
    if sorted?
      request.fullpath.include?('direction=asc') ? 'desc' : 'asc'
    else
      'desc'
    end
  end

  def get_direction_sign(direction)
    if sorted?
      direction == 'desc' ? '▲' : '▼'
    else
      ''
    end
  end
end
