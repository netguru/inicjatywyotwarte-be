# frozen_string_literal: true

module V1
  module Helpers
    module ErrorsHelpers
      extend Grape::API::Helpers

      def not_found_error!(_error = nil)
        payload = {
          code: 'not_found',
          detail: 'the specified resource couldn\'t be found'
        }
        error!({ errors: [payload] }, 404)
      end

      def forbidden_error!
        payload = {
          code: 'forbidden',
          detail: 'this action is forbidden'
        }
        error!({ errors: [payload] }, 403)
      end

      def validation_error!(item)
        error!({ errors: item.errors.messages }, :unprocessable_entity)
      end
    end
  end
end
