# frozen_string_literal: true

module Resources
  class UploadToStorage < BaseUploader
    private

    def object_key
      'cached/resources.json'
    end

    def upload_to_storage
      aws_s3_object.put(body: serialized_resources.to_json)
    end

    def serialized_resources
      serialize resources, with: ResourceSerializer
    end

    def resources
      @resources ||= Resource
                     .approved
                     .includes(:taggings)
                     .order(upvotes_count: :desc, id: :asc)
                     .with_attached_thumbnail
    end
  end
end
