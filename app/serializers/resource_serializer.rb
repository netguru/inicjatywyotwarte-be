# frozen_string_literal: true

class ResourceSerializer
  include FastJsonapi::ObjectSerializer

  set_type :resources

  attributes :name,
             :description,
             :category,
             :location,
             :target_url,
             :facebook_url,
             :ios_url,
             :android_url,
             :upvotes_count,
             :organizer,
             :contact,
             :how_to_help,
             :tag_list

  attribute :thumbnail_url do |r|
    r.thumbnail.attached? ? Rails.application.routes.url_helpers.url_for(r.thumbnail) : nil
  end

  attribute :already_upvoted, if: proc { |_, params| params[:already_upvoted_resources_ids] } do |resource, params|
    resource.id.in?(params[:already_upvoted_resources_ids])
  end
end
