# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    sequence :email do |n|
      "user.#{n}@example.com"
    end
    sequence :password do |n|
      "Pass%&0#{n}"
    end
    role { 'super_admin' }

    trait :reviewer do
      role { 'reviewer' }
    end

    trait :super_reviewer do
      role { 'super_reviewer' }
    end
  end
end
