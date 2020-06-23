# frozen_string_literal: true

class LocationSerializer
  include FastJsonapi::ObjectSerializer

  set_type :locations

  attributes :name, :resources_count
end
