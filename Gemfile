source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false

# gem "bcrypt", "~> 3.1.7"
# gem "image_processing", "~> 1.2"

gem "sassc-rails"
gem "bootstrap", "~> 5.2.0"
gem "jquery-rails"

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  # Add a comment summarizing the current schema
  gem "annotate"
  # Generate Entity-Relationship Diagrams
  gem "rails-erd"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"

  gem "rails-controller-testing"
  gem "minitest"
  gem "minitest-reporters"
  gem "guard"
  gem "guard-minitest"
end

group :production do
  gem "pg", "1.4.2"
  gem "aws-sdk-s3", "1.114.0", require: false
end

# Install the local gems while preventing the installation of production gems
# bundle config set --local without 'production'
# bundle install
# bundle lock --add-platform x86_64-linux
