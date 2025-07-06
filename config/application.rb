require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CalendarAppV1
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # APIモードを有効にする。これにより、RailsはAPIとしての動作に最適化される。
    # HTMLの生成やセッション管理など、ブラウザ向けの機能は無効化される。
    config.api_only = true

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    # Remove ActionDispatch::HostAuthorization middleware
    config.middleware.delete ActionDispatch::HostAuthorization

    puts "Autoload Paths: #{config.autoload_paths}"
    puts "Eager Load Paths: #{config.eager_load_paths}"
  end
end
