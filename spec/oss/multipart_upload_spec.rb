require 'spec_helper'

describe MultipartUpload do
  let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
  before { Base.establish_connection!(options) }

  context 'init' do
    it 'can init a multipart upload' do
      mu = MultipartUpload.initiate('2624.jpg', 'ruby-sdk')

      expect(mu).to be_a_kind_of Hash
      expect(mu[:initiate_multipart_upload_result]).to include :bucket, :key, :upload_id
    end
  end

  context 'store' do
    it 'can store file using multipart upload' do
      upload_id = MultipartUpload.initiate('2621.jpg', 'ruby-sdk')[:initiate_multipart_upload_result][:upload_id]
      mu        = MultipartUpload.store('2621.jpg', 'ruby-sdk', 1, upload_id, File.read('6764.jpg'))
    end
  end

  context 'copy' do
    it 'wil raise NoSuchKey when copy an non-existing object' do
      upload_id = MultipartUpload.initiate('2621.jpg', 'ruby-sdk')[:initiate_multipart_upload_result][:upload_id]

      expect { MultipartUpload.copy('2621.jpg', 'ruby-sdk', 1, upload_id, '2624.jpg', 1, 3) }.to raise_exception NoSuchKey
    end

    it 'can copy an existing object' do
      upload_id = MultipartUpload.initiate('2621.jpg', 'ruby-sdk')[:initiate_multipart_upload_result][:upload_id]

      mu = MultipartUpload.copy('2621.jpg', 'ruby-sdk', 1, upload_id, '6765.jpg', 1, 3)
      expect(mu).to be_a_kind_of Hash
      expect(mu[:copy_part_result]).to include :last_modified, :e_tag
    end
  end

  context 'finish' do
    it 'can finish multipart upload' do
      object = '2622.jpg'
      bucket = 'ruby-sdk'
      upload_id = MultipartUpload.initiate(object, bucket)[:initiate_multipart_upload_result][:upload_id]
      parts     = [MultipartUpload.store(object, bucket, 1, upload_id, File.read('6764.jpg'))]
      mu = MultipartUpload.finish(object, bucket, upload_id, parts)

      expect(mu).to be_a_kind_of Hash
      expect(mu[:complete_multipart_upload_result]).to include :location, :bucket, :key, :e_tag
    end
  end


  context 'abort' do
    it 'can abort multipart upload' do
      object = '2623.jpg'
      bucket = 'ruby-sdk'
      upload_id = MultipartUpload.initiate(object, bucket)[:initiate_multipart_upload_result][:upload_id]
      MultipartUpload.store(object, bucket, 1, upload_id, File.read('6764.jpg'))
      mu = MultipartUpload.abort(object, bucket, upload_id)

      expect(mu).to be_truthy
    end
  end

  context 'all' do
    it 'can list all multipart upload parts' do
      bucket = 'ruby-sdk'
      mus = MultipartUpload.all(bucket)[:list_multipart_uploads_result]

      expect(mus[:bucket]).to eq bucket
      expect(mus[:upload]).to be_a_kind_of Array
      expect(mus[:upload].first).to include :key, :upload_id, :storage_class, :initiated
    end
  end
end