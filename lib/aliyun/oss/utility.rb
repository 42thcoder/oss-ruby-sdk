module Aliyun::OSS
  class Utility
    class << self
      def parse_xml(str)
        parser.parse(str)
      end

      def build_xml(&block)
        Nokogiri::XML::Builder.new(encoding: 'UTF-8', &block).to_xml
      end

      private
      def parser
        @parser ||= Nori.new(convert_tags_to: lambda { |tag| tag.snakecase.to_sym })
      end
    end
  end
end
