# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::Create do
  subject(:service_call) { described_class.new(resource_attributes).call }

  let(:resource_attributes) do
    {
      name: name,
      category: 'neighbourly_help',
      description: 'Description',
      location: 'Paris, France',
      google_place_id: 'ChIJD7fiBh9u5kcRYJSMaMOCCwQ',
      has_facebook: true,
      has_ios: true,
      has_android: true,
      has_website: true,
      target_url: 'https://example.com/',
      contact: 'contact',
      organizer: 'organizer',
      how_to_help: 'how_to_help'
    }
  end
  let(:name) { 'Name' }

  let(:google_api_response) { file_fixture('google_geocoding_response.json').read }

  before do
    allow_any_instance_of(Resources::Locations::ValidateInGmaps).to receive(:response) { JSON.parse(google_api_response) }
  end

  it 'is a success' do
    expect(service_call).to be_success
  end

  it 'creates a resource' do
    expect { service_call }.to change(Resource, :count).by(1)
  end

  it 'set proper attributes' do
    proper_attributes = {
      name: 'Name',
      category: 'neighbourly_help',
      description: 'Description',
      location: 'Paris, France',
      google_place_id: 'ChIJD7fiBh9u5kcRYJSMaMOCCwQ',
      target_url: 'https://example.com/',
      contact: 'contact',
      organizer: 'organizer',
      how_to_help: 'how_to_help'
    }

    expect(service_call.resource).to have_attributes(proper_attributes)
  end

  it 'set proper has flags' do
    proper_has_flags = {
      has_ios: true,
      has_android: true,
      has_facebook: true,
      has_website: true
    }

    expect(service_call.resource).to have_attributes(proper_has_flags)
  end

  context 'when has_website is false' do
    subject(:service_call) { described_class.new(resource_attributes.merge(has_website: false)).call }
    it 'omits website_url' do
      expect(service_call.resource).to have_attributes(target_url: nil)
    end
  end

  context 'when validation fails' do
    subject(:service_call) do
      described_class.new(resource_attributes.merge(name: 'a' * 251)).call
    end

    it 'is a failure' do
      expect(service_call).not_to be_success
    end

    it 'has resource with errors' do
      expect(service_call.resource.errors.messages).to eq(name: ['is too long (maximum is 250 characters)'])
    end
  end
end
