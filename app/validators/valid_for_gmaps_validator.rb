# frozen_string_literal: true

class ValidForGmapsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value && record.google_place_id && location_valid?(value, record.google_place_id)

    record.errors[attribute] << (options[:message] || 'is not valid location')
  end

  private

  def location_valid?(location, google_place_id)
    validate_in_gmaps(location, google_place_id).valid?
  end

  def validate_in_gmaps(location, google_place_id)
    Resources::Locations::ValidateInGmaps.new(location, google_place_id).call
  end
end
