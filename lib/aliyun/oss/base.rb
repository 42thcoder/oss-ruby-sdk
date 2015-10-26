module Aliyun::OSS
  class Base
    include Connection::Management

    class << self
      %i(get put delete post).each do |verb|
        define_method verb do |path, headers={}, body = nil, &block|
          headers.merge!('User-Agent'=> agent)
          connection.request(verb, path, headers, body, &block)
        end
      end

      private
      def agent
        "aliyun-sdk-ruby/#{RUBY_DESCRIPTION}"
      end
    end
  end
end