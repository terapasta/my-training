module ApplicationHelper

  def get_direction
    request.fullpath.include?('direction=asc') ? 'desc' : 'asc'
  end
end
