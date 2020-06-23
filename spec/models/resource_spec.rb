# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'database columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:draft_description).of_type(:text) }
    it { is_expected.to have_db_column(:location).of_type(:string) }
    it { is_expected.to have_db_column(:google_place_id).of_type(:string) }
    it { is_expected.to have_db_column(:is_approved).of_type(:boolean) }

    # urls
    it { is_expected.to have_db_column(:target_url).of_type(:string) }
    it { is_expected.to have_db_column(:facebook_url).of_type(:string) }
    it { is_expected.to have_db_column(:ios_url).of_type(:string) }
    it { is_expected.to have_db_column(:android_url).of_type(:string) }

    # timestamps
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe 'validations' do
    it { is_expected.to validate_length_of(:name).is_at_most(250) }
    it { is_expected.to validate_length_of(:description).is_at_most(2000) }
    it { is_expected.to validate_length_of(:draft_description).is_at_most(2000) }
    it { is_expected.to validate_length_of(:location).is_at_most(100) }
    it { is_expected.to validate_length_of(:contact).is_at_most(250) }
    it { is_expected.to validate_length_of(:organizer).is_at_most(250) }
    it { is_expected.to validate_length_of(:how_to_help).is_at_most(2000) }
    it { is_expected.to validate_inclusion_of(:category).in_array(StaticData::CATEGORIES) }
  end

  describe 'conditional validations' do
    describe 'target_url presence' do
      it { is_expected.not_to validate_presence_of(:target_url) }

      context 'when approval' do
        before { allow(subject).to receive(:approval).and_return(true) }

        it { is_expected.not_to validate_presence_of(:target_url) }

        context 'when has_website true' do
          before { allow(subject).to receive(:has_website).and_return(true) }

          it { is_expected.to validate_presence_of(:target_url) }
        end
      end
    end

    describe 'facebook_url presence' do
      it { is_expected.not_to validate_presence_of(:facebook_url) }

      context 'when approval' do
        before { allow(subject).to receive(:approval).and_return(true) }

        it { is_expected.not_to validate_presence_of(:facebook_url) }

        context 'when has_facebook true' do
          before { allow(subject).to receive(:has_facebook).and_return(true) }

          it { is_expected.to validate_presence_of(:facebook_url) }
        end
      end
    end

    describe 'ios_url presence' do
      it { is_expected.not_to validate_presence_of(:ios_url) }

      context 'when approval' do
        before { allow(subject).to receive(:approval).and_return(true) }

        it { is_expected.not_to validate_presence_of(:ios_url) }

        context 'when has_ios true' do
          before { allow(subject).to receive(:has_ios).and_return(true) }

          it { is_expected.to validate_presence_of(:ios_url) }
        end
      end
    end

    describe 'android_url presence' do
      it { is_expected.not_to validate_presence_of(:android_url) }

      context 'when approval' do
        before { allow(subject).to receive(:approval).and_return(true) }

        it { is_expected.not_to validate_presence_of(:android_url) }

        context 'when has_android true' do
          before { allow(subject).to receive(:has_android).and_return(true) }

          it { is_expected.to validate_presence_of(:android_url) }
        end
      end
    end
  end

  describe 'methods' do
    describe '#approve!' do
      let(:resource) { FactoryBot.build(:resource) }

      it 'approves resource' do
        expect { resource.approve! }.to change(resource, :is_approved).from(false).to(true)
      end
    end

    describe '#disapprove!' do
      let(:resource) { FactoryBot.build(:resource, is_approved: true) }

      it 'disapproves resource' do
        expect { resource.disapprove! }.to change(resource, :is_approved).from(true).to(false)
      end
    end
  end

  describe 'scopes' do
    describe 'approved' do
      before do
        unapproved_resource
        approved_resource
      end

      let(:unapproved_resource) { FactoryBot.create(:resource, is_approved: false) }
      let(:approved_resource) { FactoryBot.create(:resource, is_approved: true) }

      it 'doesnt include unapproved' do
        expect(described_class.approved).not_to include(unapproved_resource)
      end

      it 'includes approved' do
        expect(described_class.approved).to include(approved_resource)
      end
    end

    describe 'unapproved' do
      before do
        unapproved_resource
        approved_resource
      end

      let(:unapproved_resource) { FactoryBot.create(:resource, is_approved: false) }
      let(:approved_resource) { FactoryBot.create(:resource, is_approved: true) }

      it 'doesnt include approved' do
        expect(described_class.unapproved).not_to include(approved_resource)
      end

      it 'includes unapproved' do
        expect(described_class.unapproved).to include(unapproved_resource)
      end
    end
  end

  describe 'act_as_taggable' do
    let!(:resource_1) { FactoryBot.create(:resource, :with_tags, tags: 'tag1, tag2, tag3') }
    let!(:resource_2) { FactoryBot.create(:resource, :with_tags, tags: 'tag3, tag4, tag5') }

    it 'creates 5 tags' do # tag3 is shared across both resources
      expect(ActsAsTaggableOn::Tag.count).to eq(5)
    end

    it 'assigns proper tags to resources' do
      expect(resource_1.tags.pluck(:name)).to match_array(%w[tag1 tag2 tag3])
      expect(resource_2.tags.pluck(:name)).to match_array(%w[tag3 tag4 tag5])
    end
  end
end
