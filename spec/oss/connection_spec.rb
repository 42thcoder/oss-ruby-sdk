require 'spec_helper'

describe Connection do
  let(:options) { { access_key_id: '8888', access_key_secret: 'aliyun' }.freeze }

  context 'Connection' do
    let(:connection) { Connection.new(options) }
    let(:secure_connection) { Connection.new(options.merge(use_ssl: true)) }

    it 'can create a connection' do
      expect(connection.http).to be_a Net::HTTP
    end

    it 'can set ues ssl correctly' do
      expect(secure_connection.http.use_ssl?).to be_truthy
    end

    it 'has right protocol' do
      expect(connection.protocol).to eq 'http://'
      expect(secure_connection.protocol).to eq 'https://'
    end

    it 'will throw exception unless has necessary options' do
      expect { Connection.new }.to raise_exception ArgumentError
    end
  end

  context Connection::Management do
    it 'should raise exception when you fetch connection before establishing' do
      expect { Base.connection }.to raise_exception NoConnectionEstablished
    end

    it 'can establish connection correctly' do
      Base.establish_connection!(options)

      expect(Base.connected?).to be_truthy
      expect(Base.connections['Aliyun::OSS::Base']).to be_a Connection
    end
  end
end