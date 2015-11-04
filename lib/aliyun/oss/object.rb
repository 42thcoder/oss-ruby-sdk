module Aliyun::OSS
  class OSSObject < Base
    class << self
      def create(object_name, bucket_name, file_path, location: DEFAULT_LOCATION)
        headers = { 'host'=> host(bucket_name, location) }

        put("/#{object_name}", headers: headers, body: File.read(file_path))
      end

      def get_meta(object_name, bucket_name, location: DEFAULT_LOCATION)
        headers = { 'host'=> host(bucket_name, location) }

        head("/#{object_name}", headers: headers, bucket: bucket_name, object: object_name).to_hash
      end

      def find(object_name, bucket_name, location: DEFAULT_LOCATION)
        headers = { 'host'=> host(bucket_name, location) }

        content = get("/#{object_name}", headers: headers).body
        open(object_name, 'wb') { |file| file.write(content) }
      end

    end
  end
end