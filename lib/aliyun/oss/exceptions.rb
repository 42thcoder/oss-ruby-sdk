module Aliyun::OSS
  class OSSException < StandardError
    ATTRS = %i(error_message error_code request_id host_id)
    attr_accessor *ATTRS

    def initialize(*args)
      ATTRS.each_with_index {|attr, index| self.send("#{attr.to_s}=", args[index])}
    end

    def to_s
      "#{error_message}\n[ErrorCode]: #{error_code}\n[RequestId]: #{request_id}\n[HostId]: #{host_id}"
    end
  end

  class AccessDenied < OSSException; end	#拒绝访问
  class BucketAlreadyExists < OSSException; end	#Bucket已经存在
  class BucketNotEmpty < OSSException; end	#Bucket不为空
  class EntityTooLarge < OSSException; end	#实体过大
  class EntityTooSmall < OSSException; end	#实体过小
  class FileGroupTooLarge < OSSException; end	#文件组过大
  class FilePartNotExist < OSSException; end	#文件Part不存在
  class FilePartStale < OSSException; end	#文件Part过时
  class InvalidArgument < OSSException; end	#参数格式错误
  class InvalidAccessKeyId < OSSException; end	#Access Key ID不存在
  class InvalidBucketName < OSSException; end	#无效的Bucket名字
  class InvalidDigest < OSSException; end	#无效的摘要
  class InvalidObjectName < OSSException; end	#无效的Object名字
  class InvalidPart < OSSException; end	#无效的Part
  class InvalidPartOrder < OSSException; end	#无效的part顺序
  class InvalidTargetBucketForLogging < OSSException; end	#Logging操作中有无效的目标bucket
  class InternalError < OSSException; end	#OSS内部发生错误
  class MalformedXML < OSSException; end	#XML格式非法
  class MethodNotAllowed < OSSException; end	#不支持的方法
  class MissingArgument < OSSException; end	#缺少参数
  class MissingContentLength < OSSException; end	#缺少内容长度
  class NoSuchBucket < OSSException; end	#Bucket不存在
  class NoSuchKey < OSSException; end	#文件不存在
  class NoSuchUpload < OSSException; end	#Multipart Upload ID不存在
  class NotImplemented < OSSException; end	#无法处理的方法
  class PreconditionFailed < OSSException; end	#预处理错误
  class RequestTimeTooSkewed < OSSException; end	#发起请求的时间和服务器时间超出15分钟
  class RequestTimeout < OSSException; end	#请求超时
  class SignatureDoesNotMatch < OSSException; end	#签名错误
  class TooManyBuckets < OSSException; end	#用户的Bucket数目超过限制


  class InvalidOption < OSSException ; end
  # Raised if an unrecognized option is passed when establishing a connection.
  class InvalidConnectionOption < InvalidOption
    def initialize(invalid_options)
      message = "The following connection options are invalid: #{invalid_options.join(', ')}. "    +
          "The valid connection options are: #{Connection::Options::VALID_OPTIONS.join(', ')}."
      super(message)
    end
  end

  # Raised if a request is attempted before any connections have been established.
  class NoConnectionEstablished < OSSException ;end
end
