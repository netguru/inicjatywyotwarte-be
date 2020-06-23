# frozen_string_literal: true

class UploadResourcesToStorageWorker
  include Sidekiq::Worker

  def perform
    Resources::UploadToStorage.new.call
  end
end
