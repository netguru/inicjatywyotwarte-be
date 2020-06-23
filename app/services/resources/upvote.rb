# frozen_string_literal: true

module Resources
  class Upvote
    def initialize(resource, ip_address)
      @resource = resource
      @ip_address = ip_address
    end

    attr_reader :resource, :ip_address

    def call
      upvote

      self
    end

    def success?
      upvote.valid?
    end

    private

    def upvote
      @upvote ||= resource.upvotes.create(ip_address: ip_address)
    end
  end
end
