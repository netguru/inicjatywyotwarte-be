# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

describe UploadResourcesToStorageWorker do
  it { is_expected.to be_processed_in :default }

  before { allow(Resources::UploadToStorage).to receive_message_chain(:new, :call) }

  it 'enqueues upload resources job' do
    expect do
      UploadResourcesToStorageWorker.perform_async
    end.to change(UploadResourcesToStorageWorker.jobs, :size).by(1)
  end
end
