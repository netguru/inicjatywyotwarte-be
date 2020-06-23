# frozen_string_literal: true

class ApplicationEndpoint < ::Grape::API
  def self.inherited(subclass)
    super

    subclass.default_error_status 400
  end
end
