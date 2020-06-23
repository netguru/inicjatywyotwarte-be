# frozen_string_literal: true

class Upvote < ApplicationRecord
  belongs_to :resource, counter_cache: true

  scope :voted_from, ->(ip) { where(ip_address: ip) }

  validates :ip_address, uniqueness: { scope: :resource }
end
