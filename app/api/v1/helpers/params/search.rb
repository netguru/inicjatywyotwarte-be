# frozen_string_literal: true

module V1
  module Helpers
    module Params
      module Search
        extend Grape::API::Helpers

        params :search do
          requires :query, type: String, desc: 'Search query'
        end
      end
    end
  end
end
