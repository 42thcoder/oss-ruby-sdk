module Aliyun::OSS
  class Base
    include Connection::Management

    class << self
      %i(get put delete post).each do |verb|
        define_method verb do |path, headers={}, body = nil, &block|
          request = Request.new(headers, verb)
          Response.new connection.request(verb, path, headers, body, &block)
        end
      end

      private
      def process_options!(options, verb)

      end
    end

    class Response

    end

    class Request
      def initialize(headers, verb)

      end
    end
  end
end