module Aliyun
  module OSS
    class Authentication
      OSS_HEADER_PREFIX = 'x-oss-'

      class Signature < String
        attr_accessor :access_key_id, :access_key_secret, :request, :options

        def initialize(request, access_key_id, access_key_secret, options={})
          super()
          self.request, self.access_key_id, self.access_key_secret, self.options =
              request, access_key_id, access_key_secret, options
        end

        private
        def basic
          request['host'] ||= DEFAULT_HOST
          ''.tap do |s|
            s << "#{request.method}\n"
            s << ( "#{request['content-md5']}\n" || "\n" )
            s << ( "#{request.content_type}\n" || "\n" )
          end
        end

        def encoded_canonical
          digest   = OpenSSL::Digest.new('sha1')
          p access_key_secret, basic + extra + CanonicalizeString.new(request)
          [OpenSSL::HMAC.digest(digest, access_key_secret, basic + extra + CanonicalizeString.new(request))].pack('m').strip
          # b64_hmac = [OpenSSL::HMAC.digest(digest, access_key_secret, basic + extra + CanonicalizeString.new(request))].pack('m').strip
          # CGI.escape(b64_hmac)
        end

        def date_time
          request['date'].to_s.strip.empty? ? Time.now : Time.parse(request['date'])
        end
      end


      class Header < Signature
        def initialize(*args)
          super
          self << "OSS #{self.access_key_id}:#{encoded_canonical}"
        end

        private
        def extra
          request['date'] ||= Time.current.httpdate

          "#{request['date']}\n"
        end
      end

      class URL < Signature
        DEFAULT_EXPIRY = 300

        def initialize(*args)
          super
          self << "?OSSAccessKeyId=#{access_key_id}&Expires=#{expires}&Signature=#{CGI.escape encoded_canonical}"
        end

        private
        def expires
          return options[:expires] if options[:expires]
          date_time.to_i + expires_in
        end

        def expires_in
          options.has_key?(:expires_in) ? Integer(options[:expires_in]) : DEFAULT_EXPIRY
        end

        def extra
          "#{expires}\n"
        end
      end


      class CanonicalizeString < String
        DEFAULT_HEADERS  = %w(method content-type content-md5)
        ALIYUN_HEADER_PREFIX = /^#{OSS_HEADER_PREFIX}/io
        RELEVANT_HEADERS = ['content-md5', 'content-type', 'date', ALIYUN_HEADER_PREFIX]

        attr_accessor :oss_headers, :request

        def initialize(request)
          super()

          self.request = request
          # add_basic
          build_oss_headers
          build_resources
        end


        private

        # def add_basic
        #   request['host'] ||= DEFAULT_HOST
        #   request['date'] ||= Time.current.httpdate
        #
        #   content_md5 = request['content-md5'] || '\n'
        #   content_type = request.content_type || '\n'
        #   self << "#{[request.method, content_md5, content_type, request['date']].join("\n")}\n"
        # end

        def build_oss_headers
          oss_headers.sort_by { |k, _| k }.each do |key, value|
            value = value.to_s.strip
            self << "#{key}:#{value}"
            self << "\n"
          end
        end

        def oss_headers
          return if @oss_headers

          @oss_headers = {}
          request.each do |key, value|
            key = key.downcase
            if key =~ ALIYUN_HEADER_PREFIX
              @oss_headers[key] = value.to_s.strip
            end
          end
          @oss_headers
        end

        def build_resources
          self << URI.unescape(path)
        end

        def path
          segments = request['host'].split('.')
          path = segments.size == 4 ? segments.first : request.path
          [request.path[/[&?](acl|logging)(?:&|=|$)/, 1], path[/^[^?]*/]].compact.join('?')
        end
      end
    end
  end
end