module Aliyun::OSS
  class Bucket < Base
    ACLS = %w(public-read-write public-read private)

    attr_accessor :name, :owner, :location, :creation_date

    def initialize(name)
      self.name = name
    end

    class << self
      # Create a new bucket.
      # @param [String] name name of the new bucket.
      # @param ['public-read-write' 'public-read' 'private'] acl  optional, access level of the new bucket.
      # @param [String] location optional, the location that the new object would be saved at.
      # @example Create a new Bucket named ruby-sdk
      #   Bucket.create('ruby-sdk')
      # @example By default new buckets have their access level set to private.
      #   You can override this using the `acl` option. So does location.
      #   Bucket.create('ruby-sdk', 'public', 'oss-cn-hangzhou')
      # @note You must not create more thar 10 buckets.
      # @raise [InvalidBucketName] Your bucket name must be unique across all of OSS. If the name
      #   you request has already been taken, you will get a 409 Conflict response, and a BucketAlreadyExists exception
      #   will be raised.
      # @see http://ntp.org/documentation.html NTP Documentation
      def create(name, acl: 'private', location: DEFAULT_LOCATION)
        RequestOptions.new(name, acl, location).validate!
        builder = Nokogiri::XML::Builder.new do
          CreateBucketConfiguration {
            LocationConstraint "#{location}"
          }
        end
        put('/', headers: { 'x-oss-acl' => acl, 'host' => host(name, location) }, body: builder.to_xml, bucket: name)
      end

      # @param (see .create )
      def update_acl(name, acl: 'private', location: DEFAULT_LOCATION)
        headers = { 'x-oss-acl' => acl, 'host' => host(name, location) }

        put('/?acl', headers: headers, bucket: name, query: { 'acl' => nil })
      end

      def get_location(name, location: DEFAULT_LOCATION)
        headers = { 'host' => host(name, location) }

        Response.new(get('/?location', headers: headers, bucket: name, query: { 'location' => nil })).location
      end

      def delete(name, location: DEFAULT_LOCATION)
        headers = { 'host' => host(name, location) }
        Base.delete('/', headers: headers, bucket: name)
      end

      def objects(name, date, content_type)
        get('/', { 'host' => "#{name}.oss-cn-hangzhou.aliyuncs.com", 'date' => date, 'content-type' => content_type, 'accept' => content_type })
      end
    end

    class RequestOptions
      attr_accessor :name, :acl, :location

      def initialize(name, acl, location)
        self.name, self.location, self.acl = name, location, acl
      end

      def validate!
        raise InvalidBucketName.new(name) unless name =~ /^[-\w.]{1,1023}$/
        raise InvalidLocationConstraint.new(location) unless LOCATIONS.include? location
        raise ArgumentError unless ACLS.include?(acl)
      end
    end

    class Response
      attr_accessor :body, :parser, :buckets, :owner, :location

      def initialize(response)
        super()
        self.body = response.body
      end

      def parser
        @parser ||= Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
      end

      def parse
        @result ||= parser.parse(body)
      end

      def location
        @location ||= parse[:location_constraint]
      end
    end
  end
end