require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cluster
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = { host:'localhost', port: '3000' }
    config.action_mailer.perform_deliveries = true
    config.active_job.queue_adapter = :async
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default :charset => "utf-8"
    config.action_mailer.smtp_settings = {
        :address => "smtp.gmail.com",
        :port => 587,
        :domain => 'localhost:3000',
        :user_name => ENV["gmail_username"],
        :password => ENV["gmail_password"],
        :authentication => :plain,
        :enable_starttls_auto => true
    }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
