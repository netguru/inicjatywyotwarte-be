# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

describe UploadLocationsToStorageWorker do
  it { is_expected.to be_processed_in :default }

  before { allow(Resources::Locations::UploadToStorage).to receive_message_chain(:new, :call) }

  it 'enqueues upload locations job' do
    expect do
      UploadLocationsToStorageWorker.perform_async
    end.to change(UploadLocationsToStorageWorker.jobs, :size).by(1)
  end
end
