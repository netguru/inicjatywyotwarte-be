# frozen_string_literal: true

module Resources
  class Create
    def initialize(resource_attributes)
      @resource_attributes = resource_attributes
    end

    def call
      sanitize_target_url_param
      resource.validate_location! if resource.location.present?
      resource.save

      self
    end

    def success?
      resource.valid?
    end

    def resource
      @resource ||= Resource.new(resource_attributes)
    end

    private

    def sanitize_target_url_param
      resource_attributes.delete(:target_url) unless resource_attributes[:has_website]
    end

    attr_accessor :resource_attributes
  end
end
