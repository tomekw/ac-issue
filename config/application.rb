require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.api_only = true
    config.action_cable.disable_request_forgery_protection = true
  end
end
