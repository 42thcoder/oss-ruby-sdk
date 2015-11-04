module Aliyun
  module OSS
    class Connection
      attr_accessor :options, :client

      def initialize(options={})
        self.options = Options.new(options)
      end

      def client
        @client ||= Net::HTTP.new(options[:server], options[:port]).tap do |client|
          client.use_ssl     = options[:use_ssl].present? || options[:port] == 443
          client.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      def request(verb, path, query:{}, headers:{}, body:nil, bucket:nil, object:nil)
        self.options.merge!(bucket: bucket, object: object)
        # headers['x-oss-security-token'] = sts_token
        request = Net::HTTP.const_get(verb.capitalize).new(path, headers)
        request.body = body
        add_user_agent(request)
        set_content_type(request)
        # set_content_md5(request)
        authenticate(request, query, options)

        client.request(request)
      end

      def protocol
        client.use_ssl? ? 'https://' : 'http://'
      end

      def persistent?
        options[:persistent]
      end

      private
      def authenticate(request, query, options)
        request['Authorization'] = Authentication::Header.new(request, query, options)
      end

      def add_user_agent(request)
        request['User-Agent'] = "aliyun-oss-ruby-sdk #{VERSION}/#{RUBY_DESCRIPTION}"
      end

      def set_content_type(request)
        request['Content-Type'] ||= 'application/x-www-form-urlencoded' unless request.method == 'HEAD'
      end

      def set_content_md5(request)
        request['Content-MD'] ||= Base64.encode64(Digest::MD5.digest(request.body)).strip if request.body
      end


      module Management
        extend ActiveSupport::Concern

        included do
          mattr_accessor :connections
          self.connections = {}
        end

        module ClassMethods
          attr_accessor :connections

          def establish_connection!(options={})
            options                           = default_connection.options.merge(options) if connected? && default_connection
            self.connections[connection_name] = Connection.new(options)
          end

          def connected?
            connections.present?
          end

          def connection
            if connected?
              connections[connection_name] || default_connection
            else
              raise NoConnectionEstablished
            end
          end

          def disconnect(name = connection_name)
            name       = default_connection unless connections.has_key?(name)
            connection = connections[name]
            connection.client.finish if connection.persistent?
            connections.delete(name)
          end

          def disconnect!
            connections.each_key { |connection| disconnect(connection) }
          end

          private
          def connection_name
            # name of class
            name
          end

          def default_connection_name
            'Aliyun::OSS::Base'
          end

          def default_connection
            connections[default_connection_name]
          end
        end
      end


      class Options < Hash
        VALID_OPTIONS = [:access_key_id, :access_key_secret, :server, :port, :use_ssl, :persistent].freeze

        def initialize(options = {})
          super()
          validate(options)
          replace(server: DEFAULT_HOST, port: (options[:use_ssl] ? 443 : 80))
          merge!(options)
        end

        private
        def validate(options)
          invalid_options = options.keys - VALID_OPTIONS
          raise InvalidConnectionOption.new(invalid_options) unless invalid_options.empty?
          lack_access = options[:access_key_id].nil? || options[:access_key_secret].nil?
          raise ArgumentError, 'need both access_key_id and access_key_secret' if lack_access
        end
      end
    end
  end
end