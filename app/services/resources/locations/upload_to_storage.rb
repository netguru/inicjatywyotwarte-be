# frozen_string_literal: true

module Resources
  module Locations
    class UploadToStorage < BaseUploader
      Location = Struct.new(:id, :name, :resources_count)

      private

      def object_key
        'cached/locations.json'
      end

      def upload_to_storage
        aws_s3_object.put(body: serialized_locations.to_json)
      end

      def serialized_locations
        serialize location_structs, with: LocationSerializer
      end

      def location_structs
        sorted_locations.each_with_index.map { |location, index| Location.new(index, location[0], location[1]) }
      end

      def sorted_locations
        locations.sort_by { |_key, value| value }.reverse
      end

      def locations
        @locations ||= Resource.approved.group(:location).count(:location)
      end
    end
  end
end
