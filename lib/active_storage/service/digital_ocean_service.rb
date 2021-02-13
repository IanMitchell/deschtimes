require 'aws-sdk-s3'
require 'active_storage/service/s3_service'
require 'active_support/core_ext/numeric/bytes'

# Solves multiple ActiveStorage bugs. See:
# https://github.com/rails/rails/issues/32790#issuecomment-487523740
# https://github.com/rails/rails/issues/41070#issue-782795111
module ActiveStorage
  class Service::DigitalOceanService < Service::S3Service
    attr_reader :client, :bucket, :root, :upload_options

    def initialize(bucket:, upload: {}, **options)
      @root = options.delete(:root)
      super(bucket: bucket, upload: upload, **options)
    end

    def headers_for_direct_upload(key, content_type:, checksum:, filename: nil, disposition: nil, **)
      content_disposition = content_disposition_with(type: disposition, filename: filename) if filename

      headers = public? ? { "x-amz-acl" => "public-read" } : {}

      headers.merge({
        "Content-Type" => content_type,
        "Content-MD5" => checksum,
        "Content-Disposition" => content_disposition,
      })
    end

    private
      def object_for(key)
        path = root.present? ? File.join(root, key) : key
        bucket.object(path)
      end
  end
end
