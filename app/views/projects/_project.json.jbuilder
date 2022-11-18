json.extract! project, :id, :title, :description, :url, :display_order, :created_at, :updated_at
json.url project_url(project, format: :json)
