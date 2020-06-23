# frozen_string_literal: true

module V1
  class Base < ApplicationEndpoint
    prefix :api
    version 'v1', using: :path

    content_type :json, 'application/vnd.api+json'
    default_format :json

    mount V1::Resources::Base
  end
end
