# frozen_string_literal: true

module V1
  module Helpers
    module Params
      module Resource
        extend Grape::API::Helpers

        params :resource_params do
          requires :name, type: String
          requires :category, type: String, documentation: { values: StaticData::CATEGORIES }
          requires :has_facebook, type: Boolean, values: [true, false]
          requires :has_ios, type: Boolean, values: [true, false]
          requires :has_android, type: Boolean, values: [true, false]
          requires :has_website, type: Boolean, values: [true, false]
          optional :draft_description, type: String
          optional :location, type: String
          optional :google_place_id, type: String
          optional :target_url, type: String
          optional :organizer, type: String
          optional :contact, type: String
          optional :how_to_help, type: String
        end
      end
    end
  end
end
