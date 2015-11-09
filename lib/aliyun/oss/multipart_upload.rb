module Aliyun::OSS
  class MultipartUpload < Base
    class << self
      # This operation initiates a multipart upload and returns an upload ID.
      #   This upload ID is used to associate all the parts in the specific multipart upload.
      # @param [String] object Name of object
      # @param [String] bucket
      # @param [String] location
      # @param [String] headers
      # @return [Hash] eg. { initiate_multipart_upload_result: { bucket: 'ruby-sdk', key: '123.jpg', upload_id: 'xxxx'}}
      def initiate(object, bucket, location: DEFAULT_LOCATION, headers: {})
        headers = default_headers(location, bucket).merge(headers)

        parse(post("/#{object}?uploads", headers: headers, query: { 'uploads' => nil }).body)
      end

      # This operation uploads a part in a multipart upload.
      # @param [String] object
      # @param [String] bucket
      # @param [Integer] part_num
      # @param [Integer] upload_id
      # @param [IO] file
      # @param [String] location
      # @return [Hash] eg. { part_num: 123, e_tag: 'xxxx' }
      def store(object, bucket, part_num, upload_id, file, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = "/#{object}?partNumber=#{part_num}&uploadId=#{upload_id}"
        query   = { 'partNumber' => part_num, 'uploadId' => upload_id }

        response = put(path, headers: headers, query: query, body: file)
        { part_num: part_num, e_tag: response.to_hash['etag'].first.remove("\"") }
      end


      # Uploads a part by copying data from an existing object as data source.
      def copy(object, bucket, part_num, upload_id, source_object, first, last, location: DEFAULT_LOCATION, source_bucket: bucket)
        extra   = { 'x-oss-copy-source' => "/#{source_bucket}/#{source_object}", 'x-oss-copy-source-range' => "bytes=#{first}-#{last}" }
        headers = default_headers(location, bucket).merge(extra)
        path    = "/#{object}?partNumber=#{part_num}&uploadId=#{upload_id}"
        query   = { 'partNumber' => part_num, 'uploadId' => upload_id }

        parse(put(path, headers: headers, query: query).body)
      end

      # This operation completes a multipart upload by assembling previously uploaded parts.
      def finish(object, bucket, upload_id, parts, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = "/#{object}?uploadId=#{upload_id}"
        query   = { 'uploadId' => upload_id }
        body    = build do
          CompleteMultipartUpload {
            parts.each do |part|
              Part {
                PartNumber part[:part_num]
                ETag part[:e_tag]
              }
            end
          }
        end

        parse(post(path, headers: headers, query: query, body: body).body)
      end


      # This operation aborts a multipart upload. After a multipart upload is aborted,
      #   no additional parts can be uploaded using that upload ID.
      def abort(object, bucket, upload_id, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = "/#{object}?uploadId=#{upload_id}"
        query   = { 'uploadId' => upload_id }

        Base.delete(path, headers: headers, query: query).code == '204'
      end

      # This operation lists the parts that have been uploaded for a specific multipart upload.
      # @return [Hash] eg. {list_multipart_uploads_result: bucket: 'xxx', upload: [{ key: 'xxx', upload_id: 'xxxx'}]}
      def all(bucket, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = '/?uploads'
        query   = { 'uploads' => nil }

        parse(get(path, headers: headers, query: query).body)
      end
    end
  end
end


