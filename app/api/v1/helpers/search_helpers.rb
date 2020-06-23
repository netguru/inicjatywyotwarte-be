# frozen_string_literal: true

module V1
  module Helpers
    module SearchHelpers
      extend Grape::API::Helpers

      def search_resources(query: '')
        Resource.approved
                .includes(:taggings)
                .with_attached_thumbnail
                .search_by(query)
      end

      def query
        @query ||= permitted_params[:query]
      end

      def search_meta(query)
        { query: query }
      end
    end
  end
end
