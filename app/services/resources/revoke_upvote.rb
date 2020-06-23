# frozen_string_literal: true

module Resources
  class RevokeUpvote
    def initialize(resource, ip_address)
      @resource = resource
      @ip_address = ip_address
    end

    attr_reader :resource, :ip_address

    def call
      upvote&.destroy

      self
    end

    def success?
      upvote&.destroyed?
    end

    private

    def upvote
      @upvote ||= resource.upvotes.find_by(ip_address: ip_address)
    end
  end
end
