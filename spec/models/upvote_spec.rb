# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Upvote, type: :model do
  describe 'database columns' do
    it { is_expected.to have_db_column(:ip_address).of_type(:inet).with_options(null: false) }
    it { is_expected.to have_db_column(:resource_id).of_type(:integer) }

    # timestamps
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'scopes' do
    describe 'voted_from(ip)' do
      let!(:random_upvote) { FactoryBot.create(:upvote) }
      let(:our_ip_address) { IPAddr.new('127.0.0.1') }
      let!(:our_upvote) { FactoryBot.create(:upvote, ip_address: our_ip_address) }

      it 'doesnt include random upvote' do
        expect(described_class.voted_from(our_ip_address)).not_to include(random_upvote)
      end

      it 'includes our upvote' do
        expect(described_class.voted_from(our_ip_address)).to include(our_upvote)
      end
    end
  end
end
