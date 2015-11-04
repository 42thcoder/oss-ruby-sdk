require 'spec_helper'

describe OSSObject do
  let(:bucket_name) { 'ruby-sdk' }
  let(:object_name) { '6764.jpg' }
  let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
  before { Base.establish_connection!(options) }

  context 'create' do
    it 'can create a new object' do
      OSSObject.create(object_name, bucket_name, object_name)
    end
  end

  context 'head' do
    it 'can fetch meta data of an object' do
      r = OSSObject.get_meta(object_name, bucket_name)
      p 123
      # expect(OSSObject.get_meta('6764.jpg', 'ruby-sdk')).be kind_of Hash
    end
  end

  context 'find' do
    it 'can fetch info of an object' do
      r = OSSObject.find(object_name, bucket_name)
      p 123
    end
  end
end