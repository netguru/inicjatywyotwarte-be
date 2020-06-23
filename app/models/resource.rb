# frozen_string_literal: true

class Resource < ApplicationRecord
  include PgSearch::Model

  acts_as_taggable_on :tags

  pg_search_scope :search_by,
                  against: {
                    name: 'A',
                    description: 'B',
                    location: 'C'
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  scope :approved, -> { where(is_approved: true) }
  scope :unapproved, -> { where(is_approved: false) }

  has_one_attached :thumbnail

  has_many :upvotes

  attr_accessor :approval

  validates :name, length: { maximum: 250 }
  validates :description, length: { maximum: 2000 }
  validates :draft_description, length: { maximum: 2000 }
  validates :location, length: { maximum: 100 }
  validates :google_place_id, presence: true, if: :validate_location?
  validates :location, valid_for_gmaps: true, if: :validate_location?
  validates :organizer, length: { maximum: 250 }
  validates :contact, length: { maximum: 250 }
  validates :how_to_help, length: { maximum: 2000 }
  validates :category, inclusion: { in: StaticData::CATEGORIES }

  validates :target_url, presence: true, allow_blank: false, if: proc { |r| r.approval && r.has_website.present? }
  validates :facebook_url, presence: true, allow_blank: false, if: proc { |r| r.approval && r.has_facebook.present? }
  validates :ios_url, presence: true, allow_blank: false, if: proc { |r| r.approval && r.has_ios.present? }
  validates :android_url, presence: true, allow_blank: false, if: proc { |r| r.approval && r.has_android.present? }

  def approve!
    self.approval = true
    update(is_approved: true)
  end

  def disapprove!
    update(is_approved: false)
  end

  def validate_location?
    @validate_location || false
  end

  def validate_location!
    @validate_location = true
  end
end
