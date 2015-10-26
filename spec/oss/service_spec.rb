require 'spec_helper'

describe Service do
  let(:options) { { server: DEFAULT_HOST, access_key_id: KEY_ID, access_key_secret: KEY_SECRET }}
  before { Service.establish_connection!(options) }
  let(:service) { Service.new }

  it 'should has a valid connection' do
    expect(Service.connection).not_to be_nil
  end

  it 'should make http request' do
    expect(Service.buckets).not_to be_nil
  end

  it 'has can fetch bucket list' do
    buckets = Service.buckets
    expect(buckets).to be_a_kind_of Array
    expect(buckets.first[:bucket].keys).to match_array %i(location name creation_date)
  end

  it 'can fetch owner info' do
    owner = Service.owner
    expect(owner[:id]).to be_a_kind_of String
    expect(owner[:display_name]).to be_a_kind_of String
  end
end