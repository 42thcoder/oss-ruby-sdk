module Aliyun::OSS
  class Bucket < Base
    attr_accessor :name, :owner, :location, :creation_date

    def initialize(name)
      self.name = name
    end

    def list_buckets(query, options)

    end

    class << self
      def create(name, permission)
        raise ArgumentError, 'permission got wrong value' unless %w(public-read-write public-read private).include?(permission)
        put('/', { 'x-oss-acl'=> permission, 'host'=> "#{name}.oss-cn-hangzhou.aliyuncs.com"})
      end

      def objects(name, date)
        p 'buckets'
        get('/', { 'host'=> "#{name}.oss-cn-hangzhou.aliyuncs.com", 'date'=> date })
      end
    end
  end

end