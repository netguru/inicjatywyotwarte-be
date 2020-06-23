# frozen_string_literal: true

class UploadTagsToStorageWorker
  include Sidekiq::Worker

  def perform
    Tags::UploadToStorage.new.call
  end
end
