module Aliyun::OSS
  class Base
    include Connection::Management

    class << self
      %i(get put delete post).each do |verb|
        define_method verb do |path, query:{}, headers:{}, body:nil, bucket:nil, object:nil|
          connection.request(verb, path, query: query, headers: headers, body: body, bucket: bucket, object: object)
        end
      end
    end
  end
end