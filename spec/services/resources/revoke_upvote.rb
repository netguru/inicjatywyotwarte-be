# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::RevokeUpvote do
  subject(:service_call) { described_class.new(resource, ip_address).call }

  let(:resource) { FactoryBot.create(:resource) }
  let(:ip_address) { IPAddr.new('127.0.0.1') }

  context 'when there is no upvote from this IP address' do
    it 'is a failure' do
      expect(service_call).not_to be_success
    end

    it 'doesn\'t revoke an upvote' do
      expect { service_call }.not_to change(resource.reload.upvotes, :count)
    end
  end

  context 'when there is already upvote from this IP address' do
    before { upvote }

    let(:upvote) { resource.upvotes.create(ip_address: ip_address) }

    it 'is a success' do
      expect(service_call).to be_success
    end

    it 'revokes an upvote' do
      expect { service_call }.to change(resource.reload.upvotes, :count).by(-1)
    end
  end
end
