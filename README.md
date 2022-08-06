# My Personal Portfolio Website

This is the code for my portfolio website: https://www.dipenchauhan.com

## Version
- ruby 3.1.2
- Rails 7.0.3.1

## Setup Instructions

## Deployment instructions

```
$ sudo su - postgres
$ createuser --pwprompt deploy
$ createdb -O deploy dipen_chauhan
$ psql
$ ALTER USER deploy CREATEDB;
$ GRANT ALL PRIVILEGES ON  DATABASE dipen_chauhan to deploy;
$ ALTER DATABASE dipen_chauhan owner to deploy;
$ \q
$ exit
$ bundle config set --local deployment 'true'
$ bundle
$ RAILS_ENV=production rails db:setup
$ bundle exec rake assets:precompile db:migrate RAILS_ENV=production
$ sudo service nginx reload
```

- Manually connect to DB anytime: `psql -U deploy -W -h 127.0.0.1 -d dipen_chauhan`

## What I Learned

- Add Custom Fonts to `vendor/assets/fonts`. The path is automatically added to `Rails.application.config.assets.paths`. Verify in Rails Console.


## References

- Add Custom Fonts
https://www.karinabaha.com/posts/custom-fonts-in-ruby-on-rails-7
- Deploy Rails App: https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/digital_ocean/nginx/oss/bionic/deploy_app.html
