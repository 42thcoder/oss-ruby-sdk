module Aliyun
  module OSS
    class Service < Base
      class << self
        attr_accessor :response

        def buckets
          Response.new(response).buckets
        end

        def owner
          Response.new(response).owner
        end

        private
        def response
          @response ||= get('/')
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