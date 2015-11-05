module Aliyun::OSS
  class OSSObject < Base
    class << self

      # This implementation of the PUT operation adds an object to a bucket.
      #   You must have WRITE permissions on a bucket to add an object to it.
      # @param [String] object
      # @param [String] bucket
      # @param [String] file_path
      # @param [String] location
      # @param [Hash] headers
      # @option headers [String] 'cache-control' Can be used to specify caching behavior along the request/reply chain. For more information
      # @option headers [String] 'content-disposition' Specifies presentational information for the object. For more information, go to http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1.
      # @option headers [String] 'content-encoding' Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field. For more information, go to http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.11.
      # @option headers [String] content-md5 The base64-encoded 128-bit MD5 digest of the message (without the headers) according to RFC 1864. This header can be used as a message integrity check to verify that the data is the same data that was originally sent. Although it is optional, we recommend using the Content-MD5 mechanism as an end-to-end integrity check. For more information about REST request authentication, go to REST Authentication in the Amazon Simple Storage Service Developer Guide
      # @option headers [String] expires The date and time at which the object is no longer cacheable. For more information, go to http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.21.
      # @option headers [String] x-oss-server-side-encryption Specifies a server-side encryption algorithm to use when Aliyun creates an object.
      # @option headers [String] x-oss-object-acl The canned ACL to apply to the object.
      # @return [String] 'OK'
      # @param [Boolean] append Upload mode. When false, it will create normal object; when false, it will create appendable object.
      # @param [Integer] position When append is true, you need pass this option.
      def create(object, bucket, file_path, append: false, position: nil, location: DEFAULT_LOCATION, headers: {})
        headers     = default_headers(location, bucket).merge(headers)
        path, query = append ?
          ["/#{object}?append&position=#{position}", { 'append' => nil, 'position' => position }] :
          ["/#{object}"]

        put(path, headers: headers, body: File.read(file_path), query: query).message
      end


      # This implementation of the PUT operation creates a copy of an object that is already stored in Aliyun OSS.
      # @return [Hash] eg. `{:copy_object_result=>{:last_modified=>Thu, 05 Nov 2015 20:52:29 +0000, :e_tag=>"\"97ACB5A4F68CA7723F6E4656CE79CFFB\""}} `
      # @param [String] object name of source object.
      # @param [String] bucket Name of source bucket.
      # @param [String] target_object Name of target object.
      # @param [Hash] headers
      # @param [String] location
      def copy(object, bucket, target_object, headers: {}, location: DEFAULT_LOCATION)
        source  = "/#{bucket}/#{object}"
        headers = default_headers(location, bucket).merge('x-oss-copy-source' => source).merge(headers)

        parse(put("/#{target_object}", headers: headers).body)
      end

      # The HEAD operation retrieves metadata from an object without returning the object itself.
      # @param (see .copy)
      def meta(object, bucket, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)

        head("/#{object}", headers: headers).to_hash.with_indifferent_access
      end

      # Save object to local file system.
      # @param (see .copy)
      def find(object, bucket, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)

        content = get("/#{object}", headers: headers).body
        open(object, 'wb') { |file| file.write(content) }
      end

      alias fetch find

      # The DELETE operation removes the null version (if there is one) of an object and inserts
      #   a delete marker, which becomes the current version of the object. If there isn't a null version,
      #   Aliyun OSS does not remove any objects.
      # param (see .copy)
      # @return [String] 'NoContent' means success.
      def delete(object, bucket, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)

        Base.delete("/#{object}", headers: headers).message
      end


      # This implementation of the PUT operation uses the acl subresource to set the access control list (ACL) permissions for an object that already exists in a bucket.
      # @param (see .copy)
      # @param [String] acl The desired acl you want to make your object to be.
      # @return [String] 'OK' means successful.
      def update_acl(object, bucket, acl, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket).merge('x-oss-object-acl' => acl)

        put("/#{object}?acl", headers: headers, query: { 'acl' => nil }).message
      end


      # This implementation of the GET operation uses the acl subresource to return the access control list (ACL) of an object.
      # @param (see .copy)
      # @return [Hash]
      def acl(object, bucket, location: DEFAULT_LOCATION)
        headers = default_headers(location, bucket)

        parse(get("/#{object}?acl", headers: headers, query: { 'acl' => nil }).body)
      end
    end
  end
end