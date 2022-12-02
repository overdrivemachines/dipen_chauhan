module ApplicationHelper
  # Returns active if the specified path is the current path
  # Used in the navbar partial to add active class to icons
  def active?(path)
    return "active" if request.path == path

    ''
  end

  # adds active class to li.filter in projects/index
  def filter_active?(category)
    return "active" if params[:category] == category
    return "active" if params[:category].nil? && category == "all"
  end
end
