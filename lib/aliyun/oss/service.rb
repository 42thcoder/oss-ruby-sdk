module Aliyun
  module OSS
    class Service < Base
      class << self
        def buckets
          get('/', { 'date'=> Date.tomorrow.to_datetime.httpdate })
        end
      end
    end
  end
end
