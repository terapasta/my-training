module ApplicationHelper

  def sorted?
    request.query_parameters.include?('direction')
  end

  def get_direction
    if sorted?
      request.query_parameters[:direction] == 'asc' ? 'desc' : 'asc'
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
