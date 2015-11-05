require 'spec_helper'

describe Service do
  let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET }}
  before { Base.establish_connection!(options) }
  let(:service) { Service.new }


  it 'should has a valid connection' do
    expect(Service.connection).not_to be_nil
  end

  it 'can fetch bucket list' do
    buckets = Service.buckets(max_keys: 1)
    expect(buckets).to be_a_kind_of Array
    expect(buckets.size).to eq 1
    expect(buckets.first).to include :name, :location, :creation_date
  end

  it 'can fetch owner info' do
    owner = Service.owner

    expect(owner).to include :id, :display_name
    expect(owner[:id]).to be_a_kind_of String
  end
end