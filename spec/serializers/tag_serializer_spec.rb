# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagSerializer do
  let(:tag) { FactoryBot.create(:tag) }

  it 'serializes the resource into json-api format' do
    serialized = described_class.new(tag).serializable_hash
    expect(serialized).to eq(
      data: {
        id: tag.id.to_s,
        type: :tags,
        attributes: {
          name: tag.name
        }
      }
    )
  end
end
