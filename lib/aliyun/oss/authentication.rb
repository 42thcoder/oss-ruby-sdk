module Aliyun
  module OSS
    class Authentication
      OSS_HEADER_PREFIX = 'x-oss-'

      class Signature < String
        attr_accessor :access_key_id, :access_key_secret, :request, :options, :bucket, :query, :object

        def initialize(request, query, options)
          super()
          self.request, self.access_key_id, self.access_key_secret, self.query, self.bucket, self.options, self.object =
            request, options[:access_key_id], options[:access_key_secret], query, options[:bucket], options, options[:object]
        end

        private
        def basic
          request['host'] ||= DEFAULT_HOST
          ''.tap do |s|
            s << "#{request.method}\n"
            s << ("#{request['content-md5']}\n" || "\n")
            s << ("#{request.content_type}\n" || "\n")
          end
        end

        def encoded_canonical
          digest = OpenSSL::Digest.new('sha1')
          r = basic + extra + CanonicalizeString.new(request, query, bucket, object)
          p r
          [OpenSSL::HMAC.digest(digest, access_key_secret, basic + extra + CanonicalizeString.new(request, query, bucket, object))].pack('m').strip
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

          expires_in = options.has_key?(:expires_in) ? Integer(options[:expires_in]) : DEFAULT_EXPIRY
          date_time.to_i + expires_in
        end

        def extra
          "#{expires}\n"
        end
      end


      class CanonicalizeString < String
        DEFAULT_HEADERS      = %w(method content-type content-md5)
        ALIYUN_HEADER_PREFIX = /^#{OSS_HEADER_PREFIX}/io
        RELEVANT_HEADERS     = ['content-md5', 'content-type', 'date', ALIYUN_HEADER_PREFIX]

        attr_accessor :oss_headers, :request, :bucket, :object, :query

        def initialize(request, query, bucket, object)
          super()

          self.request, self.query, self.bucket, self.object = request, query, bucket, object
          build_oss_headers
          build_resources
        end


        private
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
          self << URI.unescape(path_query)
        end

        def path_query
          override_responses = %w(response-content-type response-content-language
                                response-cache-control logging response-content-encoding acl uploadId uploads partNumber
                                group link delete website location objectInfo response-expires response-content-disposition
                                cors lifecycle restore qos referer append position).sort
          object = self.object || request.path.split('?').first.split('/').last
          bucket = self.bucket || ( request['host'].split('.').size == 4 ? request['host'].split('.').first : nil )

          result = '/'
          result += "#{bucket}/" if bucket
          result += object if object
          if query.present?
            raise ArgumentError, "invalid resources params: #{query}" if (query.keys & override_responses).blank?
            result += '?'
            tmp = query.map { |k, v| { k.downcase.strip => v } if override_responses.include?(k) }.reduce(:merge)
            tmp.each_with_index do |(k, v), index|
              result += k
              result += "=#{v}" if v
              result += '&' if index < tmp.keys.size - 1
            end
          end
          result
        end
      end
    end
  end
end
