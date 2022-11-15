task routes: :environment do
  Rails.application.eager_load!
  models = ApplicationRecord.descendants.collect(&:name).join(" -g ").prepend(" -g ").downcase
  controllers = ApplicationController.descendants.collect(&:name)
  controllers = (controllers.map { |controller| controller[0..-11].downcase.prepend(" -g ") }).join
  puts `bundle exec rails routes #{models} #{controllers}`
end
