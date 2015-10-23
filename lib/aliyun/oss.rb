require 'active_support/all'

$:.unshift(File.dirname(__FILE__))
require 'oss/version'
require 'oss/exceptions'
require 'oss/connection'
require 'oss/base'
require 'oss/bucket'


module Aliyun
  module OSS
    DEFAULT_HOST = 'oss.aliyuncs.com'
  end
end
