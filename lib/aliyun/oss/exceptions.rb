module Aliyun::OSS
  class OSSException < StandardError
    # attr_accessor :message, :code, :request_id, :host_id, :bucket_name, :object_name
    #
    # def initialize(message:, code:, request_id:, host_id:, bucket_name:nil, object_name:nil)
    #   self.message, self.code, self.request_id, self.host_id, self.bucket_name, self.object_name =
    #     message, code, request_id, host_id, bucket_name, object_name
    # end
    #
    # def to_s
    #   "#{message}\n[ErrorCode]: #{code}\n[RequestId]: #{request_id}\n[HostId]: #{host_id}"
    # end

    attr_accessor :response

    def initialize(message, response)
      self.response = response
      super(message)
    end

    def error
      return {} if response.body.blank?

      Utility::parse_xml(response.body)[:error]
    end
  end

  class AccessDenied < OSSException;
  end #拒绝访问
  class BucketAlreadyExists < OSSException;
  end #Bucket已经存在
  class BucketNotEmpty < OSSException;
  end #Bucket不为空
  class EntityTooLarge < OSSException;
  end #实体过大
  class EntityTooSmall < OSSException;
  end #实体过小
  class FileGroupTooLarge < OSSException;
  end #文件组过大
  class FilePartNotExist < OSSException;
  end #文件Part不存在
  class FilePartStale < OSSException;
  end #文件Part过时
  class InvalidArgument < OSSException;
  end #参数格式错误
  class InvalidAccessKeyId < OSSException;
  end #Access Key ID不存在
  class InvalidDigest < OSSException;
  end #无效的摘要
  class InvalidObjectName < OSSException;
  end #无效的Object名字
  class InvalidPart < OSSException;
  end #无效的Part
  class InvalidPartOrder < OSSException;
  end #无效的part顺序
  class InvalidTargetBucketForLogging < OSSException;
  end #Logging操作中有无效的目标bucket
  class InternalError < OSSException;
  end #OSS内部发生错误
  class MalformedXML < OSSException;
  end #XML格式非法
  class MethodNotAllowed < OSSException;
  end #不支持的方法
  class MissingArgument < OSSException;
  end #缺少参数
  class MissingContentLength < OSSException;
  end #缺少内容长度
  class NoSuchBucket < OSSException;
  end #Bucket不存在
  class NoSuchUpload < OSSException;
  end #Multipart Upload ID不存在
  class NotImplemented < OSSException;
  end #无法处理的方法
  class PreconditionFailed < OSSException;
  end #预处理错误
  class RequestTimeTooSkewed < OSSException;
  end #发起请求的时间和服务器时间超出15分钟
  class RequestTimeout < OSSException;
  end #请求超时
  class TooManyBuckets < OSSException;
  end #用户的Bucket数目超过限制

  class SignatureDoesNotMatch < OSSException
    def initialize(message, response)
      super

      message += "\nStringToSign: \n#{error[:string_to_sign]}"

      super(message, response)
    end
  end #签名错误

  class NoSuchKey < OSSException
    def initialize(message, response)
      super

      message += "\nKey Provided: \n#{error[:key]}"

      super(message, response)
    end
  end #文件不存在


  class InvalidOption < StandardError;
  end
# Raised if an unrecognized option is passed when establishing a connection.
  class InvalidConnectionOption < InvalidOption
    def initialize(invalid_options)
      message = "The following connection options are invalid: #{invalid_options.join(', ')}. " +
        "The valid connection options are: #{Connection::Options::VALID_OPTIONS.join(', ')}."
      super(message)
    end
  end

# Raised if a request is attempted before any connections have been established.
  class NoConnectionEstablished < StandardError;
  end

# Raise if location is invalid when create a bucket
  InvalidLocationConstraint = Class.new(OSSException)

  IllegalLocationConstraintException = Class.new(OSSException)

  TooManyBuckets    = Class.new(OSSException)

# Raise when new bucket name is invalid.
  InvalidBucketName = Class.new(OSSException)
end
