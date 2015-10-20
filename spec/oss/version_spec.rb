require 'spec_helper'

describe Aliyun::Oss::Version do
  it 'has a version number' do
    expect(Aliyun::Oss::Version.to_s).not_to be nil
  end
end
