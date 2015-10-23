module Aliyun::OSS
  class Bucket < Base
    attr_accessor :name, :owner, :location, :creation_date

    def initialize(name)
      self.name = name
    end

    def list_buckets(query, options)

    end
  end

end