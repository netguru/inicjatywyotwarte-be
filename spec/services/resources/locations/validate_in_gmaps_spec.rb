# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resources::Locations::ValidateInGmaps do
  subject(:service_call) { described_class.new(location, google_place_id).call }

  let(:google_fake_api_response) { file_fixture('google_geocoding_response.json').read }

  before do
    allow_any_instance_of(described_class).to receive(:response) { JSON.parse(google_fake_api_response) }
  end

  context 'when location matches google_place_id in response' do
    let(:location) { 'Paris, France' }
    let(:google_place_id) { 'ChIJD7fiBh9u5kcRYJSMaMOCCwQ' }

    it 'validation is successful' do
      expect(service_call.valid?).to eq(true)
    end
  end

  context 'when location doesnt match google_place_id in response' do
    let(:location) { 'Paris, France' }
    let(:google_place_id) { 'ChIJD7fiBh9u5kcDhVcSaERTR-fake' }

    it 'validation is successful' do
      expect(service_call.valid?).to eq(false)
    end
  end
end
