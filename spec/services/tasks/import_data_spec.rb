# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::ImportData do
  before do
    allow_any_instance_of(Tasks::ImportData).to receive(:puts)
  end
  subject(:service_call) { described_class.new('file_name.csv').call }

  context 'when file can be read' do
    before do
      allow(File).to receive(:read).and_return(file_fixture('fake_data.csv').read)
    end

    it 'creates resources' do
      expect { subject }.to change(Resource, :count).by(2)
    end

    it 'creates proper resource' do
      subject
      expect(Resource.first).to have_attributes(
        name: 'name1',
        description: 'desc1',
        location: 'area1, city1',
        target_url: 'link1',
        organizer: 'organizer1',
        contact: 'contact1',
        how_to_help: 'how_to_help1'
      )
    end
  end

  context 'when file cannot be read' do
    it 'creates resources' do
      expect { subject }.not_to change(Resource, :count).from(0)
    end
  end
end
