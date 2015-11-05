module Aliyun::OSS
  module Parser
    module XML
      extend ActiveSupport::Concern

      module ClassMethods
        def parse(str)
          parser.parse(str)
        end

        def build(&block)
          Nokogiri::XML::Builder.new(encoding: 'UTF-8', &block).to_xml
        end

        private
        def parser
          @parser ||= Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
        end
      end
    end
  end
end