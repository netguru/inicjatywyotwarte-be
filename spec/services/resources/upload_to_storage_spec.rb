# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::UploadToStorage do
  subject(:service_call) { described_class.new.call }

  let!(:resources) { FactoryBot.create_list(:resource, 5, :approved) }
  let(:proper_body) { ResourceSerializer.new(resources).serializable_hash.to_json }

  it 'uploads serialized resources JSON to AWS bucket' do
    aws_s3_resource = double('aws_s3_resource')
    aws_s3_object = double('aws_s3_object')
    allow(Aws::S3::Resource).to receive(:new) { aws_s3_resource }
    allow(aws_s3_resource).to receive_message_chain(:bucket, :object) { aws_s3_object }

    expect(aws_s3_object).to receive(:put).with(body: proper_body)
    service_call
  end
end
