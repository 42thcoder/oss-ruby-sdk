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
  end
end
