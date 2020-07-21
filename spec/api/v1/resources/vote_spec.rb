# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Resources::Vote, type: :request do
  subject { patch endpoint, params: params }

  before { allow_any_instance_of(Grape::Request).to receive(:ip).and_return(ip_address) }

  let(:ip_address) { IPAddr.new(FFaker::Internet.ip_v4_address) }
  let(:endpoint) { "/api/v1/resources/#{resource_id}/vote" }
  let(:resource_id) { '999' } # non existent
  let(:params) { { value: vote_value } }

  # params
  let(:vote_value) { 1 }

  context 'when resource could not be found' do
    include_examples 'returns 404'

    context 'when resource is present but unapproved' do
      let(:resource) { FactoryBot.create(:resource) }
      let(:resource_id) { resource.id }

      include_examples 'returns 404'
    end
  end

  context 'when value is missing' do
    let(:params) { {} }
    let(:expected_json) { { error: 'value is missing' } }

    include_examples 'returns 400'
  end

  context 'when value 1' do
    before do
      allow(::Resources::Upvote).to receive(:new).and_return(upvote_service_double)
      allow(upvote_service_double).to receive(:call).and_return(upvote_service_double)
    end

    let(:upvote_service_double) { double(:upvote_service, call: nil, success?: success) }
    let(:vote_value) { 1 }
    let(:resource) { FactoryBot.create(:resource, :approved) }
    let(:resource_id) { resource.id }
    let(:success) { true }

    it 'calls proper service' do
      expect(::Resources::Upvote).to receive(:new).with(resource, ip_address) { upvote_service_double }
      subject
    end

    context 'when service call is a success' do
      it 'serializes resource with proper serializer' do
        subject
        expect(response_json).to be_serialization_of(resource, with: ResourceSerializer)
      end
    end

    context 'when service call is a failure' do
      let(:success) { false }

      include_examples 'returns 403'
    end
  end

  context 'when value 0' do
    before do
      allow(::Resources::RevokeUpvote).to receive(:new).and_return(revoke_upvote_service_double)
      allow(revoke_upvote_service_double).to receive(:call).and_return(revoke_upvote_service_double)
    end

    let(:revoke_upvote_service_double) { double(:revoke_upvote_service, call: nil, success?: success) }

    let(:ip_address) { IPAddr.new(FFaker::Internet.ip_v4_address) }
    let(:vote_value) { 0 }
    let(:resource) { FactoryBot.create(:resource, :approved) }
    let(:resource_id) { resource.id }
    let(:success) { true }

    it 'calls proper service' do
      expect(::Resources::RevokeUpvote).to receive(:new).with(resource, ip_address) { revoke_upvote_service_double }
      subject
    end

    context 'when service call is a success' do
      it 'serializes resource with proper serializer' do
        subject
        expect(response_json).to be_serialization_of(resource, with: ResourceSerializer)
      end
    end

    context 'when service call is a failure' do
      let(:success) { false }

      include_examples 'returns 403'
    end
  end
end
