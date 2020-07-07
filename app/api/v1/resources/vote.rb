# frozen_string_literal: true

module V1
  module Resources
    class Vote < ApplicationEndpoint
      helpers V1::Helpers::SerializationHelpers
      helpers V1::Helpers::ErrorsHelpers
      helpers V1::Helpers::ParamsHelpers

      desc 'Retrieve existing, approved resource.',
           failure: [
             { code: 400, message: 'Bad request' },
             { code: 404, message: 'Resource not found' }
           ],
           success: [
             { code: 200, message: 'Resource found' }
           ]

      helpers do
        def resource
          @resource ||= Resource.approved.find(params[:id])
        end

        def vote_value
          @vote_value ||= permitted_params[:value]
        end
      end

      params do
        requires :value, type: Integer, desc: '0 - remove vote, 1 - upvote',
                         documentation: { values: (0..1).to_a }
      end

      patch do
        service = case vote_value
                  when 1 then ::Resources::Upvote.new(resource, request.ip).call
                  when 0 then ::Resources::RevokeUpvote.new(resource, request.ip).call
                  end

        if service.success?
          UploadResourcesToStorageWorker.perform_async
          serialize resource, with: ResourceSerializer
        else
          forbidden_error!
        end
      end
    end
  end
end
