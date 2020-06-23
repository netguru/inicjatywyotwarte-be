# frozen_string_literal: true

class API < ApplicationEndpoint
  rescue_from ActiveRecord::RecordNotFound do |error|
    not_found_error!(error)
  end

  mount V1::Base

  add_swagger_documentation(
    mount_path: '/api/docs',
    produces: 'application/vnd.api+json',
    info: {
      title: 'quarantinehelper API'
    }
  )
end
