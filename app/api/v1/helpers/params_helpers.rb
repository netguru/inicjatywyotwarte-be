# frozen_string_literal: true

module V1
  module Helpers
    module ParamsHelpers
      extend Grape::API::Helpers

      def permitted_params
        declared(params, include_missing: false)
      end
    end
  end
end
