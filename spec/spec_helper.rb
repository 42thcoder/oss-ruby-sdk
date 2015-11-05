require 'YAML'
require 'coveralls'
# require 'webmock/rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/oss'
include Aliyun::OSS

Coveralls.wear!


secrets = YAML.load_file('./secret.yml')

KEY_ID = secrets['key_id']
KEY_SECRET = secrets['key_secret']