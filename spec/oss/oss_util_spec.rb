require 'spec_helper'
require 'aliyun/oss_util'

describe 'OSS utility' do
  context 'is_ip' do
    it 'localhost should be valid' do
      expect(is_ip('localhost:3000')).to be_truthy
    end

    it '-1.1.2 should not be valid' do
      expect(is_ip('-1.1.2')).to be_falsey
    end

    it '1.1.1.1 should be valid' do
      expect(is_ip('1.1.1.1')).to be_truthy
    end

    it '1.1.1.700 should be invalid' do
      expect(is_ip('1.1.1.700')).to be_falsey
    end
  end

  context 'append_param' do
    it 'should return valid url' do
      expect(append_param('http://oss.aliyun.com', {test: 1})).to eq 'http://oss.aliyun.com?test=1'
    end
  end
end