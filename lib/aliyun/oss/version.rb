module Aliyun
  module Oss
    module Version
      MAJOR = 0
      MINOR = 1
      PATCH = 1


      # 打印语义化版本号
      # @return [String] 版本号
      def self.to_s
        [MAJOR, MINOR, PATCH].join('.')
      end
    end
  end
end
