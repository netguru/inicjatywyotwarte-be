# frozen_string_literal: true

module V1
  module Resources
    class Create < ApplicationEndpoint
      helpers V1::Helpers::SerializationHelpers
      helpers V1::Helpers::ParamsHelpers
      helpers V1::Helpers::ErrorsHelpers
      helpers V1::Helpers::Params::Resource

      desc 'Creates new resource as unapproved.',
           failure: [
             { code: 400, message: 'Bad request' },
             { code: 422, message: 'Resource validation failed' }
           ],
           success: [
             { code: 201, message: 'Resource created' }
           ]

      params do
        requires :data, type: Hash do
          requires :type, type: String, values: %w[resources]
          requires :attributes, type: Hash do
            use :resource_params
          end
        end
      end

      post do
        resource_attributes = permitted_params.fetch(:data).fetch(:attributes)

        service = ::Resources::Create.new(resource_attributes).call

        if service.success?
          status :created
          serialize service.resource, with: ResourceSerializer
        else
          validation_error!(service.resource)
        end
      end
    end
  end
end
