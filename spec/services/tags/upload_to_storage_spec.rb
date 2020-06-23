# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tags::UploadToStorage do
  subject(:service_call) { described_class.new.call }

  let(:tag1) { FactoryBot.create(:tag, name: 'tag1') }
  let(:tag2) { FactoryBot.create(:tag, name: 'tag2') }
  let(:tag3) { FactoryBot.create(:tag, name: 'tag3') }

  let(:resource1) { FactoryBot.create(:resource) }
  let(:resource2) { FactoryBot.create(:resource) }
  let(:resource3) { FactoryBot.create(:resource) }

  before do
    resource1.update(tags: [tag1, tag2, tag3])
    resource2.update(tags: [tag2, tag3])
    resource3.update(tags: [tag3])
  end

  let(:proper_body) { TagSerializer.new([tag3, tag2, tag1]).serializable_hash.to_json }

  it 'uploads serialized tags JSON to AWS bucket' do
    aws_s3_resource = double('aws_s3_resource')
    aws_s3_object = double('aws_s3_object')
    allow(Aws::S3::Resource).to receive(:new) { aws_s3_resource }
    allow(aws_s3_resource).to receive_message_chain(:bucket, :object) { aws_s3_object }

    expect(aws_s3_object).to receive(:put).with(body: proper_body)
    service_call
  end
end
