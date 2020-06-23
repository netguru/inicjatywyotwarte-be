# frozen_string_literal: true

class Ability
  include CanCan::Ability

  ROLES = %w[super_admin reviewer super_reviewer].freeze

  def initialize(user) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    user ||= AdminUser.new

    super_admin_abilities = proc do
      can :manage, :all
    end

    super_reviewer_abilities = proc do
      can :manage, ActiveAdmin::Comment
      can :read, ActiveAdmin::Page, name: 'Dashboard', namespace_name: 'admin'
      can :read, Resource
      can :manage, Resource
      can :approve, Resource
      can :disapprove, Resource
      cannot :destroy, Resource
    end

    reviewer_abilities = proc do
      can :manage, ActiveAdmin::Comment
      can :read, ActiveAdmin::Page, name: 'Dashboard', namespace_name: 'admin'
      can :read, Resource
      can :manage, Resource, is_approved: false
      cannot :destroy, Resource
      cannot :disapprove, Resource
      cannot :approve, Resource
    end

    case user.role
    when 'super_admin'
      super_admin_abilities.call
    when 'super_reviewer'
      super_reviewer_abilities.call
    when 'reviewer'
      reviewer_abilities.call
    end
  end
end
