require 'spec_helper'

describe Authentication do
  let(:key_id) { '44CF9590006BF252F707' }
  let(:key_secret) { 'OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV' }
  let(:request) { Net::HTTP::Put.new('/oss-example/nelson') }

  context Authentication::Signature do
    it 'should be a string' do
      expect(Authentication::Signature.new(request, key_id, key_secret)).to be_a_kind_of String
    end
  end

  context Authentication::Header do
    before do
      request['Content-Type'] = 'text/html'
      request['Content-Md5'] = 'ODBGOERFMDMzQTczRUY3NUE3NzA5QzdFNUYzMDQxNEM='
      request['Date'] = 'Thu, 17 Nov 2005 18:49:58 GMT'
      request['X-OSS-Meta-Author'] = 'foo@bar.com'
      request['X-OSS-Magic'] = 'abracadabra'
    end
    it 'should be a string' do
      expect(Authentication::Header.new(request, key_id, key_secret)).to be_a_kind_of String
    end

    it 'should have valid value' do
      auth = "OSS #{key_id}:26NBxoKdsyly4EDv6inkoDft/yA="
      expect(Authentication::Header.new(request, key_id, key_secret)).to eq auth
    end
  end

  context Authentication::URL do
    let(:request) { Net::HTTP::Get.new('/oss-example/oss-api.pdf') }
    let(:expires) { 1141889120 }
    it 'should be a string' do
      expect(Authentication::URL.new(request, key_id, key_secret, { expires: expires})).to be_a_kind_of String
    end

    it 'should have valid value' do
      # TODO 文档里写的跟Python 跑出来的不一样
      auth = "?OSSAccessKeyId=44CF9590006BF252F707&Expires=1141889120&Signature=EwaNTn1erJGkimiJ9WmXgwnANLc%3D"
      expect(Authentication::URL.new(request, key_id, key_secret, { expires: expires})).to eq auth
    end
  end
end