require 'spec_helper'

describe OSSObject do
  context 'create' do
    let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET } }
    before { OSSObject.establish_connection!(options) }

    it 'can create a new object' do
      OSSObject.create('')
    end
  end
end