source "https://rubygems.org"


gem "rails", "~> 8.1.3", ">= 8.1.3.1"
gem "propshaft" # The modern asset pipeline
gem "puma", ">= 5.0" # Use the Puma web server
gem "jsbundling-rails" # Bundle and transpile JavaScript
gem "cssbundling-rails" # Bundle and process CSS
gem "turbo-rails" # Hotwire's SPA-like page accelerator
gem "stimulus-rails" # Hotwire's modest JavaScript framework

gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "kamal", require: false # Deploy this application anywhere as a Docker container
gem "thruster", require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma

gem "image_processing", "~> 1.2" # Use Active Storage variants

gem "auto_strip_attributes", "~> 2.6" # Remove unnecessary whitespaces from ActiveRecord or ActiveModel attributes
gem "validate_url" # adds the capability of validating URLs to ActiveRecord and ActiveModel.
gem "premailer-rails", "~> 1.12" # Inline email CSS before delivery.
gem "bcrypt" # used for password
gem "mail_form", "~> 1.9" # Contact us form
gem "acts_as_list" # store ordered list in db


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  gem "bundler-audit", require: false # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "brakeman", require: false # Static analysis for security vulnerabilities
  gem "rubocop-rails-omakase", require: false # Omakase Ruby styling

  gem "sqlite3", "~> 2.9" # Use SQLite3 as the database for Active Record

  gem "erb_lint", require: false # Lint ERB templates
end

group :development do
  gem "erbfmt", "0.3.1", require: false # Format HTML+ERB templates

  gem "web-console" # Add a comment summarizing the current schema
  gem "chrome_devtools_rails" # Expose Chrome DevTools workspace mapping metadata in development.

  gem "letter_opener" # Preview emails

  gem "rails-erd" # Entity-Relationship Diagrams for Rails applications
  gem "ruby-graphviz" # Graphviz output support for rails-erd PNG/PDF/SVG diagrams
  gem "chusaku", require: false # Controller annotations
  gem "annotaterb" # Annotate models, routes, fixtures, etc.

  gem "down" # Download files for seed data
  gem "pexels" # Get images from pexels.com
  gem "faker" # Generate fake data for testing and development
end

group :production do
  gem "pg", "~> 1.6" # Use postgresql as the database for AR
end
