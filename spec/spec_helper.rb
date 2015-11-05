require 'coveralls'
# require 'webmock/rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/oss'
include Aliyun::OSS

Coveralls.wear!

Dotenv.load

KEY_ID = ENV['KEY_ID']
KEY_SECRET = ENV['KEY_SECRET']