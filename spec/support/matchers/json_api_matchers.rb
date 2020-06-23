# frozen_string_literal: true

def be_serialization_of(object, options)
  serializer = options.delete(:with)
  raise 'you need to pass a serializer' if serializer.nil?

  serialized = serializer.new(object, options).serializable_hash
  match(serialized.as_json.deep_symbolize_keys)
end
