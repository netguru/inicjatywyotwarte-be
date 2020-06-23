# frozen_string_literal: true

FactoryBot.define do
  factory :upvote do
    ip_address { IPAddr.new(FFaker::Internet.ip_v4_address) }
    resource
  end
end
