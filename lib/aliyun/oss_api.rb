require 'oss_util'

# A simple OSS API
class OssAPI
  DEFAULT_CONTENT_TYPE = 'application/octet-stream'
  provider             = PROVIDER
  __version__          = '0.4.2'
  VERSION              = __version__
  AGENT                = "aliyun-sdk-ruby/#{__version__} #{RUBY_DESCRIPTION}"


  attr_accessor :send_buffer_size, :recv_buffer_size, :host, :port, :access_id, :secret_access_key,
                :show_bar, is_security, :retry_times, :agent, :debug, :timeout, :is_oss_domain,
                :sts_token


  def initialize(host='oss.aliyuncs.com', access_id='', secret_access_key='', port=80, is_security=false, sts_token=nil)
    self.send_buffer_size  = 8192
    self.recv_buffer_size  = 1024 * 1024 * 10
    self.host              = get_host_from_list(host)
    self.port              = port
    self.access_id         = access_id
    self.secret_access_key = secret_access_key
    self.show_bar          = false
    self.is_security       = is_security || (self.port == 43)
    self.retry_times       = 5
    self.agent             = AGENT
    self.debug             = false
    self.timeout           = 60
    self.is_oss_domain     = false
    self.sts_token         = sts_token
  end


  def get_connection(tmp_host=self.host)
    host           = ''
    port           = 80
    host_port_list = tmp_host.split(':')
    if host_port_list.size == 1
      host = host_port_list[0].strip
    elsif host_port_list.size == 2
      host = host_port_list[0].strip
      port = host_port_list[1].strip
    end

    # TODO 设置超时
    http             = Net::HTTP.new(host, port)
    http.use_ssl     = self.is_security
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

# Create the authorization for OSS based on the input method, url, body and headers
#
# @param method [String] one of PUT, GET, DELETE, HEAD
# @param url [String]  address of bucket or object, eg: http://HOST/bucket/object
# @param headers [Object]
# @param resource [String] path of bucket or object, eg: /bucket/ or /bucket/object
# @param [Integer] timeout
#
# @return [String] signature url
  def sign_url_auth_with_expire_time(method, url, headers={}, resource='/', timeout=60, params={})


    # if not headers
    #   :
    #       headers = {}
    #   if not params
    #     :
    #         params               = {}
    #     send_time                = str(int(time.time()) + timeout)
    #     headers['Date']          = send_time
    #     auth_value               = get_assign(self.secret_access_key, method, headers, resource, None, self.debug)
    #     params["OSSAccessKeyId"] = self.access_id
    #     params["Expires"]        = str(send_time)
    #     params["Signature"]      = auth_value
    #     sign_url                 = append_param(url, params)
    #     return sign_url
    #   end
  end


# Create bucket
  def create_bucket(bucket, acl='', headers=nil)
    self.put_bucket(bucket, acl, headers)
  end

  def put_bucket(bucket, acl='', headers=nil)
    '' '
        Create bucket

        :type bucket: string
        :param

        :type acl: string
        :param: one of private public-read public-read-write

        :type headers: dict
        :param: HTTP header

        Returns:
            HTTP Response
        ' ''
    headers          ||= {}
    acl_key          = (self.provider == 'AWS') ? 'x-amz-acl' : 'x-oss-acl'
    headers[acl_key] = acl

    method = 'PUT'
    object = ''
    body   = ''
    params = {}
    self.http_request(method, bucket, object, headers, body, params)

  end

  def http_request(method, bucket, object, headers=nil, body='', params=nil)
    # '' '
    #     Send http request of operation
    #
    #     :type method: string
    #     :param method: one of PUT, GET, DELETE, HEAD, POST
    #
    #     :type bucket: string
    #     :param
    #
    #     :type object: string
    #     :param
    #
    #     :type headers: dict
    #     :param: HTTP header
    #
    #     :type body: string
    #     :param
    #
    #     Returns:
    #         HTTP Response
    #     ' ''
    5.times do
      tmp_bucket  = bucket
      tmp_object  = object
      tmp_headers = {}
      tmp_params  = {}
      tmp_headers = headers.copy if headers && headers.is_a?(Hash)
      tmp_params  = params.copy if params and params.is_a? Hash

      res = self.http_request_with_redirect(method, tmp_bucket, tmp_object, tmp_headers, body, tmp_params)
      if check_redirect(res)
        self.host = helper_get_host_from_resp(res, bucket)
      else
        return res
      end
      return res
    end
  end


  def http_request_with_redirect(method, bucket, object, headers=nil, body='', params=nil)
    '' '
        Send http request of operation

        :type method: string
        :param method: one of PUT, GET, DELETE, HEAD, POST

        :type bucket: string
        :param

        :type object: string
        :param

        :type headers: dict
        :param: HTTP header

        :type body: string
        :param

        Returns:
            HTTP Response
        ' ''
    params                        ||= {}
    headers                       ||= {}
    headers['x-oss-security-token'] = self.sts_token if self.sts_token
    object                          = convert_utf8(object)
    if bucket.nil?
      resource        = '/'
      headers['Host'] = self.host
    else
      headers['Host'] = "#{bucket}.#{self.host}"
      unless is_oss_host?(self.host, self.is_oss_domain)
        headers['Host'] = self.host
      end
      resource = "/#{bucket}/"
    end

    resource = convert_utf8(resource)
    resource = "#{resource}#{object}#{get_resource(params)}"
    object   = oss_quote(object)
    url      = "/#{object}"
    if is_ip(self.host)
      url             = "/#{bucket}/#{object}"
      url             = "/#{object}" if bucket.nil?
      headers['Host'] = self.host
    end

    url                      = append_param(url, params)
    headers['Date']          = Time.current.strftime('%a, %d %b %Y %H:%M:%S GMT')
    headers['Authorization'] = self._create_sign_for_normal_auth(method, headers, resource)
    headers['User-Agent']    = self.agent
    if check_bucket_valid(bucket) && !is_ip(self.host)
      conn = self.get_connection(headers['Host'])
    else
      conn = self.get_connection
    end

    conn.send_request(method, url, body, headers)
  end

end



