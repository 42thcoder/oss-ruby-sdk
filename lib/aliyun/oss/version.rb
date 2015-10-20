module Aliyun
  module Oss
    module Version
      MAJOR    = '0'
      MINOR    = '6'
      TINY     = '3'
      BETA     = nil # Time.now.to_i.to_s
    end

    VERSION = [Version::MAJOR, Version::MINOR, Version::TINY, Version::BETA].compact * '.'
  end
end
