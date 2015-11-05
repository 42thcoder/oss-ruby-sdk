module Aliyun::OSS
  class Base
    include Connection::Management

    class << self
      %i(get put delete post head).each do |verb|
        define_method verb do |path, query:{}, headers:{}, body:nil, bucket:nil, object:nil|
          response = connection.request(verb, path, query: query, headers: headers, body: body, bucket: bucket, object: object)

          if response.is_a? Net::HTTPSuccess
            response
          else
            p response.body
            raise ResponseError.new(response).find_or_create_exception!
          end
        end
      end


      private
      def host(name, location)
        "#{name}.#{location}.aliyuncs.com"
      end
    end

    class ResponseError
      attr_accessor :status, :body, :response, :error

      def initialize(response)
        self.response, self.status, self.error =
          response, response.code, Utility.parse_xml(response.body)[:error]
      end

      def find_or_create_exception!
        @exception = Aliyun::OSS.const_defined?(error[:code]) ? find_exception : create_exception
      end

      private
      def find_exception
        Aliyun::OSS.const_get(error[:code]).new(response, error[:message])
      end

      def create_exception
        Aliyun::OSS.const_set(code, Class.new(OSSException))
      end
    end
  end
end