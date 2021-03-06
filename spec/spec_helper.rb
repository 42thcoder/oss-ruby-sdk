require 'coveralls'
require 'webmock/rspec'
require 'vcr'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'aliyun/oss'
require 'codeclimate-test-reporter'

include Aliyun::OSS

Coveralls.wear!
CodeClimate::TestReporter.start

Dotenv.load


KEY_ID = ENV['KEY_ID']
KEY_SECRET = ENV['KEY_SECRET']


VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/'
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.around(:each) do |example|
    options = (example.metadata[:vcr] || {})
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
      VCR.use_cassette(name, options, &example)
    end
  end
end