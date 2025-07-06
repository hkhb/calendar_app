# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # 本番では限定する

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end