module Aliyun
  module OSS
    class Service < Base
      class << self
        # fetch all the buckets current user have
        # @param [String] prefix
        # @param [String] marker
        # @param [Integer] max_keys
        def buckets(prefix:nil, marker:nil, max_keys:100)
          raise ArgumentError, 'max_keys must be less than 1000' if max_keys > 1000
          Response.new(get('/')).buckets
        end

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
          @parser ||= Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
        end

        def parse
          @result ||= parser.parse(body)[:list_all_my_buckets_result]
        end

        def buckets
          @buckets ||= parse[:buckets]
          @buckets = [@buckets] unless @buckets.is_a? Array
        end

        def owner
          @owner ||= parse[:owner]
        end
      end
    end
  end
end