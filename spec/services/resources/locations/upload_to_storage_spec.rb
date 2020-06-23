# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::Locations::UploadToStorage do
  subject(:service_call) { described_class.new.call }

  let!(:resource1) { FactoryBot.create(:resource, :approved, location: 'location1') }
  let!(:resource2) { FactoryBot.create(:resource, :approved, location: 'location1') }
  let!(:resource3) { FactoryBot.create(:resource, :approved, location: 'location2') }

  let(:aws_s3_resource) { double('aws_s3_resource') }
  let(:aws_s3_object) { double('aws_s3_object') }

  let(:proper_body) do
    {
      data: [
        { id: '0', type: :locations, attributes: { name: 'location1', resources_count: 2 } },
        { id: '1', type: :locations, attributes: { name: 'location2', resources_count: 1 } }
      ]
    }.to_json
  end

  it 'uploads serialized resources JSON to AWS bucket' do
    allow(Aws::S3::Resource).to receive(:new) { aws_s3_resource }
    allow(aws_s3_resource).to receive_message_chain(:bucket, :object) { aws_s3_object }

    expect(aws_s3_object).to receive(:put).with(body: proper_body)
    service_call
  end
end
