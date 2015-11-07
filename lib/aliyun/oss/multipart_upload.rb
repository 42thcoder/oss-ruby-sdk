module Aliyun::OSS
  class MultipartUpload < Base
    class << self
      def initiate(object, bucket, location: DEFAULT_LOCATION, headers: {})
        headers = default_headers(location, bucket).merge(headers)

        parse(post("/#{object}?uploads", headers: headers, query: { 'uploads' => nil }).body)
      end

      def store(object, bucket, part_num, upload_id, file, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = "/#{object}?partNumber=#{part_num}&uploadId=#{upload_id}"
        query   = { 'partNumber' => part_num, 'uploadId' => upload_id }

        response = put(path, headers: headers, query: query, body: file)
        { part_num: part_num, e_tag: response.to_hash['etag'].first.remove("\"") }
      end

      def copy(object, bucket, part_num, upload_id, source_object, first, last, location: DEFAULT_LOCATION, source_bucket: bucket)
        extra   = { 'x-oss-copy-source' => "/#{source_bucket}/#{source_object}", 'x-oss-copy-source-range' => "bytes=#{first}-#{last}" }
        headers = default_headers(location, bucket).merge(extra)
        path    = "/#{object}?partNumber=#{part_num}&uploadId=#{upload_id}"
        query   = { 'partNumber' => part_num, 'uploadId' => upload_id }

        parse(put(path, headers: headers, query: query).body)
      end

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

      def abort(object, bucket, upload_id, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = "/#{object}?uploadId=#{upload_id}"
        query   = { 'uploadId' => upload_id }

        Base.delete(path, headers: headers, query: query).code == '204'
      end

      def all(bucket, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)
        path    = '/?uploads'
        query   = { 'uploads' => nil }

        parse(get(path, headers: headers, query: query).body)
      end
    end
  end
end


