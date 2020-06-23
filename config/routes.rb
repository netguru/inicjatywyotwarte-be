# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  host = Rails.application.credentials.host || 'http://localhost:3000'
  Rails.application.routes.default_url_options[:host] = host

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/health' => 'health#check'

  mount API => '/'

  authenticate :admin_user do
    mount GrapeSwaggerRails::Engine => '/swagger'
    get '/', to: redirect('/swagger')
    mount Sidekiq::Web => '/sidekiq'
    mount Crono::Web, at: '/crono'
  end
end
