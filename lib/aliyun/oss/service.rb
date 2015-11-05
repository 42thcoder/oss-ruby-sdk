module Aliyun
  module OSS
    class Service < Base
      class << self
        # Fetch all the buckets current user have.
        # @param [String] prefix Optional. Restrict the prefix of returned buckets.
        # @param [String] marker Optional. Restrict that returned buckets must be after the marker
        # @param [Integer] max_keys Optional. Restrict the max amount of the returned buckets, default value is 10.
        # @return [Array] eg. [{:bucket=>{:location=>"oss-cn-hangzhou", :name=>"ruby-sdk", :creation_date=>Mon, 26 Oct 2015 08:23:05 +0000}}]
        # @example
        #   Service.buckets
        def buckets(prefix:nil, marker:nil, max_keys: 100)
          raise ArgumentError, 'max_keys must be less than 1000' if max_keys > 1000
          query = { 'prefix'=> prefix, 'marker'=> marker, 'max-keys'=> max_keys }.compact
          
          Response.new(get("/?#{query}", query: query)).buckets
        end

        # Fetch info of owner.
        # @return [Hash] eg. {:id=>"xxxxx", :display_name=>"xxxxx"}
        def owner
          Response.new(get('/')).owner
        end
      end

      class Response
        attr_accessor :body, :parser, :buckets, :owner

        def initialize(response)
          super()
          self.body = response.body
        end

        def parser
          @parser = Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
        end

        def parse
          @result = parser.parse(body)[:list_all_my_buckets_result]
        end

        def buckets
          @buckets = parse[:buckets]
          @buckets = [@buckets] unless @buckets.is_a? Array
        end

        def owner
          @owner = parse[:owner]
        end
      end
    end
  end
end