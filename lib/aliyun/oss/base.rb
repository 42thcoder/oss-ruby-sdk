module Aliyun::OSS
  class Base
    include Connection::Management

    class << self
      %i(get put delete post).each do |verb|
        define_method verb do |path, headers={}, body = nil, &block|
          p 123
          p headers
          connection.request(verb, path, headers, body, &block)
        end
      end
    end
  end
end