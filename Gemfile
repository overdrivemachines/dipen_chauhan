source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.4.2"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
# gem "jbuilder"
gem "bootsnap", require: false
gem "sassc-rails"
gem "bootstrap", "~> 5.2.0"
gem "image_processing", ">= 1.2"
gem "validate_url" # adds the capability of validating URLs to ActiveRecord and ActiveModel.
gem "bcrypt" # used for password
gem "mail_form", "~> 1.9" # Contact us form
gem "acts_as_list" # store ordered list in db


group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "sqlite3", "~> 1.4"
end

group :development do
  gem "web-console"
  # Add a comment summarizing the current schema
  gem "annotate"
  # Generate Entity-Relationship Diagrams
  gem "rails-erd"

  # Format ERB Files
  gem "erb-formatter"

  # Preview emails
  gem "letter_opener"

  # Annotate controllers
  gem "chusaku", require: false
  # Download files for seed data
  gem "down"
  # Get images from pexels.com
  gem "pexels"
end

group :production do
  gem "pg", "1.4.2"
end

# Install the local gems while preventing the installation of production gems
# bundle config set --local without 'production'
# bundle install
# bundle lock --add-platform x86_64-linux
