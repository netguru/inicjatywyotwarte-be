# frozen_string_literal: true

module V1
  module Helpers
    module PaginationHelpers
      extend Grape::API::Helpers

      params :pagination do
        optional :page, type: Hash do
          optional :number, type: Integer, desc: 'Which page of records to access'
          optional :size, type: Integer, desc: 'Nr of records to show per page'
        end
      end

      def paginate(collection)
        page = declared(params).fetch(:page)
        collection.page(page.fetch(:number)).per(page.fetch(:size))
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          current_per_page: collection.limit_value,
          total_count: collection.total_count,
          total_pages: collection.total_pages
        }
      end
    end
  end
end
