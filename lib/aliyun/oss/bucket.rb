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
      # @param ['public-read-write' 'public-read' 'private'] acl  Optional, access level of the new bucket.
      #   See /file/ACL.md
      # @param [String] location optional, the location that the new object would be saved at.
      # @return [String] 'OK'
      # @example Create a new Bucket named ruby-sdk
      #   Bucket.create('ruby-sdk')
      # @example By default new buckets have their access level set to private.
      #   You can override this using the `acl` option. So does location.
      #   Bucket.create('ruby-sdk', 'public', 'oss-cn-hangzhou')
      # @raise [InvalidBucketName] Your bucket name must be unique across all of OSS. If the name
      #   you request has already been taken, you will get a 409 Conflict response, and a BucketAlreadyExists exception
      #   will be raised.
      # @raise [InvalidLocationConstraint] The specified location constraint is not valid.
      # @raise [BucketAlreadyExists] The requested bucket name is not available. The bucket
      #   namespace is shared by all users of the system.
      # @raise [TooManyBuckets] You have attempted to create more buckets than allowed which is 10.
      def create(name, acl: 'private', location: DEFAULT_LOCATION)
        body    = Utility.build_xml do
          CreateBucketConfiguration {
            LocationConstraint location
          }
        end
        headers = { 'x-oss-acl' => acl, 'host' => host(name, location) }

        put('/', headers: headers, body: body, bucket: name).message
      end

      # Set the permissions on an existing bucket
      # @param (see .create )
      def update_acl(name, acl: 'private', location: DEFAULT_LOCATION)
        headers = { 'x-oss-acl' => acl, 'host' => host(name, location) }

        put('/?acl', headers: headers, bucket: name, query: { 'acl' => nil })
      end


      # Set the logging parameters for a bucket and to specify permissions
      #   for who can view and modify the logging parameters. To set the
      #   logging status of a bucket, you must be the bucket owner.
      # @param [String] name  Specifies the bucket where you want Aliyun OSS to store server access logs.
      # @param [String] prefix This element lets you specify a prefix for the objects that the log files will be stored.
      # @param [:open, :close] pivot Open the log when :open and close the log when :close
      # @param [Object] location
      # @return [String] 'OK'
      def update_logging(pivot, name, prefix: nil, location: DEFAULT_LOCATION)
        body    = if pivot == :open
                    Utility.build_xml do
                      BucketLoggingStatus {
                        LoggingEnabled {
                          TargetBucket name
                          TargetPrefix prefix if prefix
                        }
                      }
                    end
                  else
                    Utility.build_xml { BucketLoggingStatus {} }
                  end
        headers = default_headers(location, name)

        put('/?logging', headers: headers, body: body, query: { 'logging' => nil }).message
      end

      # @param [String] name
      # @param [String] location
      # @param [String] suffix A suffix that is appended to a request that is for a directory
      #   on the website endpoint (e.g. if the suffix is index.html and you make a request to
      #   samplebucket/images/ the data that is returned will be for the object with the key
      #   name images/index.html) The suffix must not be empty and must not include a slash character.
      # @param [String] error_key The object key name to use when a 4XX class error occurs.
      def generate_website(name, suffix, location: DEFAULT_LOCATION, error_key: nil)
        headers = default_headers(location, name)
        body    = Utility.build_xml do
          WebsiteConfiguration {
            IndexDocument {
              Suffix suffix
            }
            ErrorDocument {
              Key error_key if error_key
            }
          }
        end

        put('/?website', headers: headers, body: body, query: { 'website' => nil }).message
      end

      # Update the refer of a bucket.
      # @param [String] name
      # @param [Boolean] allow_empty
      # @param [Array[String]] referers
      # @param [String] location
      # @return [String] 'OK'
      def update_referer(name, allow_empty, referers, location: DEFAULT_LOCATION)
        headers = default_headers(location, name)
        body    = Utility.build_xml do
          RefererConfiguration {
            AllowEmptyReferer allow_empty
            RefererList {
              referers.each { |r| Referer r }
            }
          }
        end

        put('/?referer', headers: headers, body: body, query: { 'referer' => nil })
      end

      # Creates a new lifecycle configuration for the bucket or replaces an existing lifecycle configuration.
      # @param [String] name
      # @param [Array[Hash]] rules Hash got listed keys:
      #   - id Integer. Optional, Unique identifier for the rule.
      #   - prefix String. Object key prefix identifying one or more objects to which the rule applies.
      #   - status ['Enabled', 'Disabled'] If Enabled, Aliyun OSS executes the rule as scheduled.
      #     If Disabled, Aliyun OSS ignores the rule.
      #   - days Integer. Specifies the number of days after object creation when the specific rule action takes effect.
      #   - date Date. Specifies the date after which you want the corresponding action to take effect.
      # @param [String] location
      # @return [String] 'OK'
      # @example
      #   Bucket.update_lifecycle('ruby-sdk', [{prefix: 'test', status: 'Enabled', days: 1}])
      def update_lifecycle(name, rules, location: DEFAULT_LOCATION)
        headers = default_headers(location, name)
        body    = Utility.build_xml do
          LifecycleConfiguration {
            rules.each do |rule|
              Rule {
                ID rule[:id] if rule[:id]
                Prefix rule[:prefix]
                Status rule[:status]
                Expiration {
                  Days rule[:days] || rule[:date]
                }
              }
            end
          }
        end

        put('/?lifecycle', headers: headers, body: body, query: { 'lifecycle' => nil }).message
      end


      # This implementation of the GET operation returns some or all (up to 1000) of the objects in a bucket.
      # @return [Hash] Detail of the target bucket.
      #     eg. `{:list_bucket_result=> {:name=>"ruby-sdk", :prefix=>nil, :marker=>nil,
      #     :max_keys=>"100", :delimiter=>nil, :is_truncated=>false, :contents=>[{:key=>"6764.jpg",
      #     :last_modified=>Thu, 05 Nov 2015 14:32:34 +0000, :e_tag=>"\"97ACB5A4F68CA7723F6E4656CE79CFFB\"",
      #     :type=>"Normal", :size=>"4143", :storage_class=>"Standard", :owner=>{:id=>"1889927870986049", :display_name=>"1889927870986049"}}}]}}`
      # @param [String] name name of target bucket.
      # @param [String] location Optional, location of target bucket.
      def find(name, location: DEFAULT_LOCATION)
        headers = default_headers(location, name)

        Utility.parse_xml(get('/', headers: headers).body)
      end


      # This implementation of the GET operation uses the acl subresource to return the access control list (ACL) of a bucket.
      # @return [Hash]
      #   eg. `{:access_control_policy=>{:owner=>{:id=>"1889927870986049",
      #   :display_name=>"1889927870986049"}, :access_control_list=>{:grant=>"private"}}}`
      # @param (see .find)
      def acl(name, location: DEFAULT_LOCATION)
        detail(:acl, location, name)
      end


      # This implementation of the GET operation uses the location subresource to return a bucket's region.
      # @param (see .find)
      # @return eg. `{:location_constraint=>"oss-cn-hangzhou"} `
      def location(name, location: DEFAULT_LOCATION)
        detail(:location, location, name)
      end

      # This implementation of the GET operation returns the website configuration associated with a bucket.
      # @return eg. `{:website_configuration=>{:index_document=>{:suffix=>"test"}}} `
      # @param (see .find)
      def website(name, location: DEFAULT_LOCATION)
        detail(:website, location, name)
      end

      # Fetch referer config of specified bucket.
      # @return eg. `{:referer_configuration=>{:allow_empty_referer=>true, :referer_list=>{:referer=>["http://www.*.com", "http://www.aliyun.com"]}}} `
      # @param (see .find)
      def referer(name, location: DEFAULT_LOCATION)
        detail(:referer, location, name)
      end

      # This implementation of the GET operation uses the logging subresource to return the logging status of a bucket and the permissions users have to view and modify that status.
      # @return eg. `{:list_bucket_result=>{:name=>"ruby-sdk", :prefix=>nil, :marker=>nil, :max_keys=>"100", :delimiter=>nil, :is_truncated=>false, :contents=>[{:key=>"6764.jpg", :last_modified=>Thu, 05 Nov 2015 14:32:34 +0000, :e_tag=>"\"97ACB5A4F68CA7723F6E4656CE79CFFB\"", :type=>"Normal", :size=>"4143", :storage_class=>"Standard", :owner=>{:id=>"1889927870986049", :display_name=>"1889927870986049"}}, {:key=>"6764.jpg123", :last_modified=>Wed, 04 Nov 2015 15:37:34 +0000, :e_tag=>"\"97ACB5A4F68CA7723F6E4656CE79CFFB\"", :type=>"Normal", :size=>"4143", :storage_class=>"Standard", :owner=>{:id=>"1889927870986049", :display_name=>"1889927870986049"}}]}} `
      # @param (see .find)
      def lifecyle(name, location: DEFAULT_LOCATION)
        detail(:lifecyle, location, name)
      end

      # Returns the lifecycle configuration information set on the bucket.
      # @return eg. `{:bucket_logging_status=>{:logging_enabled=>nil}}`
      # @param (see .find)
      def logging(name, location: DEFAULT_LOCATION)
        detail(:logging, location, name)
      end

      # @return [String]  'No Content' means success.
      # @param [String] name
      # @param [String] location
      # @param [Symbol] aspect [:website, :logging, :lifecycle] Which aspect you want to delete.
      def delete(name, location: DEFAULT_LOCATION, aspect: nil)
        path, query = aspect ? ["/?#{aspect}", { aspect.to_s => nil }] : '/'
        headers     = default_headers(location, name)

        Base.delete(path, headers: headers, query: query).message
      end

      def objects(name, date, content_type)
        get('/', { 'host' => "#{name}.oss-cn-hangzhou.aliyuncs.com", 'date' => date, 'content-type' => content_type, 'accept' => content_type })
      end

      private
      def detail(aspect, location, name)
        headers = default_headers(location, name)

        Utility.parse_xml(get("/?#{aspect.to_s}", headers: headers, query: { aspect.to_s => nil }).body)
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