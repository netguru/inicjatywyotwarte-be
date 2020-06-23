# frozen_string_literal: true

class UploadLocationsToStorageWorker
  include Sidekiq::Worker

  def perform
    Resources::Locations::UploadToStorage.new.call
  end
end
