require 'spec_helper'

describe Bucket do
  context 'create' do
    let(:options) { { server: 'oss.aliyun.com', access_key_id: KEY_ID, access_key_secret: KEY_SECRET }}
    before { Bucket.establish_connection!(options) }

    it 'can create public read bucket' do
      # p Bucket.create('ruby-sdk-test', 'public-read-write')
    end

    it 'can create public read bucket' do
      p date = Time.now.httpdate
      r = Bucket.objects('ruby-sdk', date)
      r
    end
  end
end