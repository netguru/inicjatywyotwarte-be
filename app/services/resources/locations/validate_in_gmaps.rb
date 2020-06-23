# frozen_string_literal: true

require 'http'

module Resources
  module Locations
    class ValidateInGmaps
      def initialize(location, google_place_id)
        @location = location
        @google_place_id = google_place_id
      end

      def call
        @valid = true if ok_status? && place_id_matches_location?

        self
      end

      def valid?
        @valid || false
      end

      private

      attr_reader :location, :valid, :google_place_id

      def place_id_matches_location?
        response['results'].any? { |result| result['place_id'] == google_place_id }
      end

      def ok_status?
        response['status'] == 'OK'
      end

      def response
        @response ||= JSON.parse(request.body)
      end

      def request
        HTTP.get(url)
      end

      def url
        "#{geocode_endpoint}?address=#{escaped_location}&key=#{api_key}"
      end

      def escaped_location
        CGI.escape(location)
      end

      def api_key
        Rails.application.credentials.dig(:google_maps_platform, :api_key)
      end

      def geocode_endpoint
        Rails.application.credentials.dig(:google_maps_platform, :geocode_endpoint)
      end
    end
  end
end
