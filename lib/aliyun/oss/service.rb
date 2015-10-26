module Aliyun
  module OSS
    class Service < Base
      class << self
        def buckets
          response = get('/', { 'date'=> Date.tomorrow.to_datetime.httpdate })
          p get('/').body
        end
      end
    end
  end
end
