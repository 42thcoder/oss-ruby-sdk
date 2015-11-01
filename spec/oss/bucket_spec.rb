require 'spec_helper'

describe Bucket do
  context 'create' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET }}
    before { Bucket.establish_connection!(options) }

    it 'will raise exception when name is invalid' do
      expect { Bucket.create('') }.to raise_exception InvalidBucketName
      expect { Bucket.create('1' * 1024) }.to raise_exception InvalidBucketName
      expect { Bucket.create('\1') }.to raise_exception InvalidBucketName
      expect { Bucket.create('1\\') }.to raise_exception InvalidBucketName
    end

    it 'can create public read bucket' do
      Bucket.create('ruby-sdk-123')
    end
  end

  context 'update' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
    before { Bucket.establish_connection!(options) }

    it 'can update acl of a existing bucket' do
      Bucket.update_acl('ruby-sdk', acl: 'private')
    end

    it 'can fetch the location of a existing bucket' do
      Bucket.get_location('ruby-sdk')
    end
  end

  context 'delete' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
    before do
      Base.establish_connection!(options)
      Bucket.establish_connection!(options)
    end

    it 'can delete a empty bucket' do
      Bucket.delete('ruby-sdk-123')
    end
  end
end