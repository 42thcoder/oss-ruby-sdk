module Aliyun::OSS
  class Client
    attr_accessor :options

    def initialize(options={})
      self.options = Options.new(options)
    end

    class Options < Hash
      VALID_OPTIONS   = %i(access_key_id access_key_secret host port is_security).freeze
      DEFAULT_OPTIONS = {
          region:   'oss-cn-hangzhou',
          internal: false,
          timeout:  60,
          bucket:   nil,
          endpoint: nil,
          cname:    nil
      }

      def initialize(options = {})
        super()
        validate(options)

        merge!(DEFAULT_OPTIONS).merge!(options)
      end

      private
      def validate(options)
        invalid_options = options.keys - VALID_OPTIONS
        raise ArgumentError, 'require accessKeyId, accessKeySecret' if options[:access_key_id].nil? || options[:access_key_secret].nil?
        raise InvalidConnectionOption.new(invalid_options) unless invalid_options.empty?
      end
    end
  end
end