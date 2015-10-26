require 'spec_helper'

describe Service do
  let(:options) { { server: 'oss.aliyun.com', access_key_id: KEY_ID, access_key_secret: KEY_SECRET }}
  before { Service.establish_connection!(options) }
  let(:service) { Service.new }

  it 'should has a valid connection' do
    expect(Service.connection).not_to be_nil
  end

  it 'should make http request' do
    expect(Service.buckets).not_to be_nil
  end
end