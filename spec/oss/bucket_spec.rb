require 'spec_helper'

describe Bucket do
  context 'create' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET }}
    before { Base.establish_connection!(options) }

    it 'will raise exception when name is invalid' do
      expect { Bucket.create('****') }.to raise_exception InvalidBucketName
    end

    it 'will raise exception when name is too long' do
      expect { Bucket.create('1' * 1024) }.to raise_exception InvalidBucketName
    end

    it 'can create public read bucket' do
      expect(Bucket.create('ruby-sdk-xxxx')).to eq 'OK'
    end
  end

  context 'update' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
    before { Bucket.establish_connection!(options) }

    it 'can update acl of an existing bucket' do
      Bucket.update_acl('ruby-sdk', acl: 'private')
    end

    it 'can open log for a bucket' do
      expect(Bucket.update_logging(:open, 'ruby-sdk')).to eq 'OK'
    end

    it 'can close log for a bucket' do
      expect(Bucket.update_logging(:close, 'ruby-sdk')).to eq 'OK'
    end

    it 'can update website of a bucket' do
      expect(Bucket.generate_website('ruby-sdk', 'test')).to eq 'OK'
    end

    it 'can update refer of a bucket' do
      expect(Bucket.update_referer('ruby-sdk',true, %w(http://www.aliyun.com http://www.*.com)))
    end

    it 'can update lifecycle of a bucket' do
      expect(Bucket.update_lifecycle('ruby-sdk', [{prefix: 'test', status: 'Enabled', days: 1}])).to eq 'OK'
    end
  end

  context 'find' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
    before { Bucket.establish_connection!(options) }

    it 'can find bucket based on the name' do
      bucket = Bucket.find('ruby-sdk')[:list_bucket_result]
      expect(bucket).to be_a_kind_of Hash
      expect(bucket).to include :name, :prefix, :max_keys
      expect(bucket[:contents].first).to include :key, :e_tag
    end


    it 'can fetch the location of an existing bucket' do
      location = Bucket.location('ruby-sdk')

      expect(location).to be_a_kind_of Hash
      expect(location[:location_constraint]).to be_a_kind_of String
    end

    it 'can fetch the acl of a bucket' do
      acl = Bucket.acl('ruby-sdk')
      expect(acl).to be_a_kind_of Hash
      expect(acl[:access_control_policy]).to include :owner, :access_control_list
      expect(acl[:access_control_policy][:owner][:id]).to be_a_kind_of String
    end

    it 'can fetch logging config' do
      logging = Bucket.logging('ruby-sdk')
      expect(logging).to be_a_kind_of Hash
      expect(logging).to include :bucket_logging_status
    end

    it 'can fetch website config' do
      website = Bucket.website('ruby-sdk')
      expect(website).to be_a_kind_of Hash
      expect(website).to include :website_configuration
      expect(website[:website_configuration]).to include :index_document
    end

    it 'can fetch referer config' do
      referer = Bucket.referer('ruby-sdk')

      expect(referer).to be_a_kind_of Hash
      expect(referer).to include :referer_configuration
      expect(referer[:referer_configuration]).to include :allow_empty_referer, :referer_list
    end

    it 'can fetch lifecyle config' do
      lifecyle = Bucket.lifecyle('ruby-sdk')
      expect(lifecyle).to be_a_kind_of Hash
      # expect(lifecyle).to include :bucket_logging_status
      # expect(lifecyle[:bucket_logging_status]).to include :logging_enabled
    end
  end

  context 'delete' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
    before { Base.establish_connection!(options) }

    it 'can delete a empty bucket' do
      expect(Bucket.delete('123-ruby')).to eq 'No Content'
    end

    it 'can close website of bucket' do
      expect(Bucket.delete('ruby-sdk', aspect: :website)).to eq 'No Content'
    end

    it 'can close logging of bucket' do
      expect(Bucket.delete('ruby-sdk', aspect: :logging)).to eq 'No Content'
    end

    it 'can close lifecycle of bucket' do
      expect(Bucket.delete('ruby-sdk', aspect: :lifecycle)).to eq 'No Content'
    end
  end
end