# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResourceSerializer do
  let(:resource) { FactoryBot.create(:resource, :with_tags, tags: 'tag1, tag2, tag3') }

  it 'serializes the resource into json-api format' do
    serialized = described_class.new(resource).serializable_hash
    expect(serialized).to eq(
      data: {
        id: resource.id.to_s,
        type: :resources,
        attributes: {
          name: resource.name,
          description: resource.description,
          location: resource.location,
          category: resource.category,
          target_url: resource.target_url,
          facebook_url: resource.facebook_url,
          ios_url: resource.ios_url,
          android_url: resource.android_url,
          thumbnail_url: nil,
          upvotes_count: 0,
          organizer: resource.organizer,
          contact: resource.contact,
          how_to_help: resource.how_to_help,
          tag_list: %w[tag1 tag2 tag3]
        }
      }
    )
  end

  context 'when receives IP adress in params that already voted' do
    before { resource.upvotes.create(ip_address: ip_address) }

    let(:ip_address) { IPAddr.new('127.0.0.1') }

    it 'returns already voted as true' do
      serialized = described_class.new(
        resource,
        { params: { already_upvoted_resources_ids: [resource.id] } }
      ).serializable_hash

      expect(serialized[:data][:attributes][:already_upvoted]).to eq(true)
    end
  end
end
