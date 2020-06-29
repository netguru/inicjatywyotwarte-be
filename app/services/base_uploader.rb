# frozen_string_literal: true

require 'aws-sdk-s3'

class BaseUploader
  include V1::Helpers::SerializationHelpers

  def call
    upload_to_storage
  end

  def upload_to_storage
    raise NotImplementedError
  end

  def object_key
    raise NotImplementedError
  end

  private

  def aws_s3_object
    @aws_s3_object ||= aws_s3_resource
                       .bucket(Rails.env.development? ? 'local-bucket' : Rails.application.credentials.dig(:aws, :bucket))
                       .object(object_key)
  end

  def aws_s3_resource
    @aws_s3_resource ||= Aws::S3::Resource.new(options)
  end

  def options
    options = { region: Rails.application.credentials.dig(:aws, :region) }
    if Rails.env.development?
      options = {
        region: 'eu-central-1',
        endpoint: 'http://localhost:4572',
        force_path_style: true
      }
    end
    options
  end
end
