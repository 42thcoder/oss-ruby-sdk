require 'spec_helper'

describe OSSObject do
  let(:bucket_name) { 'ruby-sdk' }
  let(:object_name) { '6764.jpg' }
  let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
  before { Base.establish_connection!(options) }

  context 'create' do
    it 'can create a new object' do
      expect(OSSObject.create(object_name, bucket_name, object_name)).to eq 'OK'
    end
  end

  context 'head' do
    it 'can fetch meta data of an object' do
      meta = OSSObject.meta(object_name, bucket_name)
      expect(meta).to be_a_kind_of Hash
      expect(meta).to include :date, 'content-length', :etag, 'last-modified'
    end
  end

  context 'find' do
    it 'can fetch info of an object' do
      expect(OSSObject.find(object_name, bucket_name)).to be_truthy
    end

    it 'can fetch acl info of object' do
      acl = OSSObject.acl('6765.jpg', 'ruby-sdk')

      expect(acl).to be_a_kind_of Hash
      expect(acl[:access_control_policy]).to include :owner, :access_control_list
    end
  end

  context 'copy' do
    it 'can copy existing object' do
      object = OSSObject.copy('6764.jpg', 'ruby-sdk', '6765.jpg')
      expect(object).to be_a_kind_of Hash
      expect(object[:copy_object_result]).to include :last_modified, :e_tag
    end
  end

  context 'delete' do
    it 'can delete an object' do
      expect(OSSObject.delete('6764.jpg', 'ruby-sdk')).to eq 'No Content'
    end
  end


  context 'update' do
    it 'can update acl of an object' do
      expect(OSSObject.update_acl('6765.jpg', 'ruby-sdk', 'public-read-write')).to eq 'OK'
    end
  end
end