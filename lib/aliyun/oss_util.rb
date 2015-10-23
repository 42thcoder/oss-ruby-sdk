require 'uri'
require 'active_support'

# LOG_LEVEL can be one of DEBUG INFO ERROR CRITICAL WARNNING
DEBUG                     = false
LOG_LEVEL                 = "DEBUG"
PROVIDER                  = "OSS"
SELF_DEFINE_HEADER_PREFIX = "x-oss-"
if "AWS" == PROVIDER
  SELF_DEFINE_HEADER_PREFIX = "x-amz-"
end

OSS_HOST_LIST = %w(aliyun-inc.com aliyuncs.com alibaba.net s3.amazonaws.com)


def get_host_from_list(hosts)
  tmp_list = hosts.split(',')
  if tmp_list.size <= 1
    return hosts
  else
    tmp_list.each do |tmp_host|
      tmp_host = tmp_host.strip
      host     = tmp_host
      port     = 80
      begin
        host_port_list = tmp_host.split(':')
        if host_port_list.size == 1
          host = host_port_list[0].strip
        elsif host_port_list.size == 2
          host = host_port_list[0].strip
          port = int(host_port_list[1].strip)
        end

        sock = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
        sock.connect(Socket.pack_sockaddr_in(port, host))
        return host
      rescue
        # TODO maybe just pass
        raise 'invalid hosts'
      end
    end
  end
  tmp_list[0].strip
end

def convert_utf8(input_string)
  input_string.force_encoding('UTF-8')
end

def is_oss_host?(host, is_oss_domain=false)
  is_oss_domain || OSS_HOST_LIST.include?(host)
end

def oss_quote(in_str)
  URI.escape(in_str.to_s)
end

def is_ip(s)
  list = s.split('.')
  s.start_with?('localhost:') || (list.size == 4 && list.map(&:to_i).all? { |i| i >= 0 && i <= 255 })
rescue
  false
end

def get_resource(params=nil)
  return '' if params.nil?

  tmp_headers = {}
  params.each do |k, v|
    tmp_k              = k.lower.strip
    tmp_headers[tmp_k] = v
  end
  override_response_list = %w(response-content-type response-content-language response-cache-control logging response-content-encoding acl uploadId uploads partNumber group link delete website location objectInfo response-expires response-content-disposition cors lifecycle restore qos referer append position)
  override_response_list.sort!
  resource  = ''
  separator = '?'
  override_response_list.each do |i|
    if tmp_headers.key?(i.lower)
      resource += separator
      resource += i
      tmp_key  = tmp_headers[i.lower].to_s
      if tmp_key.size != 0
        resource += '='
        resource += tmp_key
      end
      separator = '&'
    end
  end
  resource
end

# convert the parameters to query string of URI.
def append_param(url, params)
  "#{url}?#{params.to_query}"
end
