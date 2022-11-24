module ApplicationHelper
  # Returns active if the specified path is the current path
  # Used in the navbar partial to add active class to icons
  def active?(path)
    return "active" if request.path == path

    ''
  end
end
