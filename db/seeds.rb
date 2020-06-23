# frozen_string_literal: true

if Rails.env.development?
  puts 'Creating super_admin...'
  super_admin = AdminUser.create!(email: 'superadmin@example.com',
                                  password: 'password',
                                  password_confirmation: 'password',
                                  role: 'super_admin')
  puts "Created super_admin: #{super_admin.email}"

  puts 'Creating reviewer...'
  reviewer = AdminUser.create!(email: 'reviewer@example.com',
                               password: 'password',
                               password_confirmation: 'password',
                               role: 'reviewer')
  puts "Created reviewer: #{reviewer.email}"

  puts 'Creating super_reviewer...'
  super_reviewer = AdminUser.create!(email: 'superreviewer@example.com',
                                     password: 'password',
                                     password_confirmation: 'password',
                                     role: 'super_reviewer')
  puts "Created super reviewer: #{super_reviewer.email}"
end

puts 'Creating five unapproved resources...'
5.times { FactoryBot.create(:resource) }
puts 'Created'

puts 'Creating ten approved resources'
10.times { FactoryBot.create(:resource, :approved) }
puts 'Created'
