# frozen_string_literal: true

module Tags
  class UploadToStorage < BaseUploader
    private

    def object_key
      'cached/tags.json'
    end

    def upload_to_storage
      aws_s3_object.put(body: serialized_tags.to_json)
    end

    def serialized_tags
      serialize tags, with: TagSerializer
    end

    def tags
      @tags ||= ActsAsTaggableOn::Tag.order(taggings_count: :desc)
    end
  end
end
