# User.create(email: "get.dipen@gmail.com", first_name: "Dipen", last_name: "Chauhan", login: "helloworld")

# Category.create(name: "Hidden", abbr: "Hidden")
# Category.create(name: "Ruby on Rails", abbr: "RoR")
# Category.create(name: "JavaScript", abbr: "JS")
# Category.create(name: "C++", abbr: "C++")

def download_images
  client = Pexels::Client.new(Rails.application.credentials.pexel[:api_key])

  # Download 23 pictures for projects
  response = client.photos.curated(page: 1, per_page: 23)
  response.each do |photo|
    url = photo.src["large"]
    Down.download(url, destination: Rails.root.join('db/seeds/projects/'))
  end
end

# download_images

project_files_path = Dir[Rails.root.join('db/seeds/projects/*.jpeg')]

project_files_path.each do |project_file_path|
  project = Project.new(title: Faker::Game.title + Faker::Game.genre,
                        description: Faker::Hacker.say_something_smart,
                        code_url: Faker::Internet.url,
                        live_url: Faker::Internet.url,
                        category_id: Category.all.pluck(:id).sample)

  project.image.attach(io: File.open(project_file_path), filename: "#{Faker::Internet.base64}.jpeg")
  project.save!
end
