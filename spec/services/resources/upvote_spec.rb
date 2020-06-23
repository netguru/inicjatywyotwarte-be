# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::Upvote do
  subject(:service_call) { described_class.new(resource, ip_address).call }

  let(:resource) { FactoryBot.create(:resource) }
  let(:ip_address) { IPAddr.new('127.0.0.1') }

  it 'is a success' do
    expect(service_call).to be_success
  end

  it 'creates an upvote' do
    expect { service_call }.to change(resource.reload.upvotes, :count).by(1)
  end

  it 'assigns an ip address to upvote object' do
    service_call

    expect(resource.reload.upvotes.last.ip_address).to eq(ip_address)
  end

  context 'when already voted' do
    before { resource.upvotes.create(ip_address: ip_address) }

    it 'is a failure' do
      expect(service_call).not_to be_success
    end

    it 'doesn\'t create an upvote' do
      expect { service_call }.not_to change(resource.reload.upvotes, :count).from(1)
    end

    context 'when another guest' do
      subject(:service_call) { described_class.new(resource, ip_address_2).call }

      let(:ip_address_2) { IPAddr.new('127.0.0.2') }

      it 'is a success' do
        expect(service_call).to be_success
      end
    end
  end
end
