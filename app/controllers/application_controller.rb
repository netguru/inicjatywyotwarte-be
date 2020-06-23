# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, alert: exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end
end
