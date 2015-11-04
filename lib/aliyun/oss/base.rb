module Aliyun::OSS
  class Base
    include Connection::Management

    class << self
      %i(get put delete post head).each do |verb|
        define_method verb do |path, query:{}, headers:{}, body:nil, bucket:nil, object:nil|
          connection.request(verb, path, query: query, headers: headers, body: body, bucket: bucket, object: object)
        end
      end


      private
      def host(name, location)
        "#{name}.#{location}.aliyuncs.com"
      end
    end
  end
end