require 'active_support/all'
require 'nokogiri'
require 'nori'

$:.unshift(File.dirname(__FILE__))
require 'oss/version'
require 'oss/exceptions'
require 'oss/authentication'
require 'oss/connection'
require 'oss/base'
require 'oss/bucket'
require 'oss/service'


module Aliyun
  module OSS
    DEFAULT_HOST = 'oss-cn-hangzhou.aliyuncs.com'
    LOCATIONS = %w(oss-cn-hangzhou oss-cn-qingdao oss-cn-beijing oss-cn-hongkong oss-cn-shenzhen oss-cn-shanghai oss-us-west-1 oss-ap-southeast-1)
    DEFAULT_LOCATION = 'oss-cn-hangzhou'
  end
end
