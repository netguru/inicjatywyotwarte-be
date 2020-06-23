# frozen_string_literal: true

module V1
  module Helpers
    module SerializationHelpers
      def serialize(resource, options)
        serializer_options = options.dup
        serializer = serializer_options.delete(:with) || raise('no serializer given')
        serializer.new(resource, serializer_options).serializable_hash
      end
    end
  end
end
