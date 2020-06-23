# frozen_string_literal: true

module V1
  module Resources
    class Base < ApplicationEndpoint
      namespace :resources do
        route_param :id do
          namespace :vote do
            mount V1::Resources::Vote
          end
        end

        mount V1::Resources::Create
      end
    end
  end
end
