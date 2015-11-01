module Aliyun::OSS
  class OSSObject < Base
    class << self
      def create(name, location: DEFAULT_LOCATION)
        headers = { 'host'=> host(name, location) }
        put("/#{name}", headers: headers)
      end
    end
  end
end