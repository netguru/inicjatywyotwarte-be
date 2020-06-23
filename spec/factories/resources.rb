# frozen_string_literal: true

FactoryBot.define do
  factory :resource do
    name { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    location { FFaker::Address.city }
    category { StaticData::CATEGORIES.sample }
    organizer { FFaker::Name.name }
    contact { FFaker::PhoneNumberPL.phone_number }
    how_to_help { FFaker::Lorem.paragraph }

    target_url { "https://www.facebook.com/#{FFaker::Lorem.word}" }
    ios_url { "https://www.apps.apple.com/#{FFaker::Lorem.word}" }
    android_url { "https://www.apps.android.google.com/#{FFaker::Lorem.word}" }
    facebook_url { "https://www.facebook.com/#{FFaker::Lorem.word}" }

    trait :approved do
      is_approved { true }
    end

    transient do
      tags {}
    end

    trait :with_tags do
      tag_list { tags || FFaker::Lorem.word }
    end

    trait :with_google_place_id do
      google_place_id { SecureRandom.hex(10) }
    end
  end
end
