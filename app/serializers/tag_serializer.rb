# frozen_string_literal: true

class TagSerializer
  include FastJsonapi::ObjectSerializer

  set_type :tags

  attributes :name
end
