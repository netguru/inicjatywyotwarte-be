# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Resources::Create, type: :request do
  subject { post endpoint, params: params }

  let(:endpoint) { '/api/v1/resources' }
  let(:params) do
    {
      data: {
        type: 'resources',
        attributes: {
          name: 'Name',
          category: 'neighbourly_help',
          description: 'Description',
          location: 'Location',
          has_facebook: true,
          has_ios: true,
          has_android: true,
          has_website: true,
          target_url: 'https://example.com/',
          organizer: 'organizer',
          contact: 'contact',
          how_to_help: 'how to help'
        }
      }
    }
  end

  context 'when params empty' do
    let(:params) { {} }
    let(:expected_json) { { error: error } }
    let(:error) do
      'data is missing,'\
      ' data[type] is missing,'\
      ' data[attributes] is missing,'\
      ' data[attributes][name] is missing,'\
      ' data[attributes][category] is missing,'\
      ' data[attributes][has_facebook] is missing,'\
      ' data[attributes][has_ios] is missing,'\
      ' data[attributes][has_android] is missing,'\
      ' data[attributes][has_website] is missing'
    end

    include_examples 'returns 400'
  end

  context 'when params are proper' do
    before do
      allow(::Resources::Create).to receive(:new).and_return(service_double)
      allow(service_double).to receive(:call).and_return(service_double)
    end

    let(:service_double) { double('service', success?: true, resource: resource) }
    let(:resource) { FactoryBot.create(:resource) }

    it 'serializes resource with proper serializer' do
      subject
      expect(response_json).to be_serialization_of(resource, with: ResourceSerializer)
    end

    include_examples 'returns 201'
  end

  context 'when creator service validation fails' do
    before do
      resource.save
      allow(::Resources::Create).to receive(:new).and_return(service_double)
      allow(service_double).to receive(:call).and_return(service_double)
    end

    let(:service_double) { double('service', success?: false, resource: resource) }
    let(:resource) { FactoryBot.build(:resource, name: 'a' * 251) }
    let(:expected_json) { { errors: { name: ['is too long (maximum is 250 characters)'] } } }

    include_examples 'returns 422'
  end
end
