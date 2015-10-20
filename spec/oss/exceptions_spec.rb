require 'spec_helper'

describe Aliyun::Oss::OSSException do
  it 'can display formatted message' do
    e = Aliyun::Oss::OSSException.new(1, 2, 3, 4)
    expect(e.to_s).not_to be nil
  end
end
