# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValidForGmapsValidator do
  let(:validator) { described_class.new({ attributes: %i[location] }) }
  let(:resource) { FactoryBot.build_stubbed(:resource, :with_google_place_id) }
  let(:service_mock) { double('service_mock') }

  before do
    allow_any_instance_of(Resources::Locations::ValidateInGmaps).to receive(:call) { service_mock }
    allow(service_mock).to receive_message_chain(:call) { service_mock }
    allow(service_mock).to receive_message_chain(:valid?) { service_response }
  end

  context 'when validation service returns failure' do
    let(:service_response) { false }

    it 'adds errors' do
      validator.validate_each(resource, :location, 'Paris')
      expect(resource.errors.messages).to eq({ location: ['is not valid location'] })
    end
  end

  context 'when validation service returns success' do
    let(:service_response) { true }

    it 'doesnt add errors' do
      validator.validate_each(resource, :location, 'Paris')
      expect(resource.errors.messages).to be_empty
    end
  end
end
