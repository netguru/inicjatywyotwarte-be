# frozen_string_literal: true

ActiveAdmin.register ActsAsTaggableOn::Tag, as: 'Tag' do
  permit_params :name

  controller do
    after_action :regenerate_tags_json, only: %i[create destroy update]

    def regenerate_tags_json
      UploadTagsToStorageWorker.perform_async
    end
  end
end
