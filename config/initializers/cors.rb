# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/*',
             headers: :any,
             methods: %i[get post put patch delete options head]

    # this is for when we serve fonts via Rails directly -- dev and staging
    resource '/assets/*',
             headers: :any,
             methods: %i[get options head]
  end
end
