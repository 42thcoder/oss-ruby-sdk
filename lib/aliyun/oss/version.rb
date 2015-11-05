module Aliyun
  module OSS
    module Version
      MAJOR    = '0'
      MINOR    = '1'
      TINY     = '0'
      BETA     = '1' # Time.now.to_i.to_s
    end

    VERSION = [Version::MAJOR, Version::MINOR, Version::TINY, Version::BETA].compact * '.'
  end
end
