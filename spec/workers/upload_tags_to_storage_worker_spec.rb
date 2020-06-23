# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

describe UploadTagsToStorageWorker do
  it { is_expected.to be_processed_in :default }

  before { allow(Tags::UploadToStorage).to receive_message_chain(:new, :call) }

  it 'enqueues upload tags job' do
    expect do
      UploadTagsToStorageWorker.perform_async
    end.to change(UploadTagsToStorageWorker.jobs, :size).by(1)
  end
end
