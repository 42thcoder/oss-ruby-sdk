# Walk Through Guide

Aliyun::OSS is a Ruby SDK for Aliyun's Open Storage Service, aka [OSS](http://www.aliyun.com/product/oss/). If you want to access full
 API documentation, just visit the help page [here](https://docs.aliyun.com/?spm=5176.383663.13.7.VXxXyZ#/pub/oss/api-reference/abstract). 
  
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aliyun-ruby-oss'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oss-sdk

For Rails Project, you are good to go. For plain Ruby Project, you need `require 'aliyun/oss'`

## Set Up

### Establish Connection

Before you can do anything, you must establish a connection using Base.establish_connection!.  A basic connection would look something like this:
 
```ruby
  Aliyun::OSS::Base.establish_connection!(
    access_key_id:     'key', 
    access_key_secret: 'id'
  )
```
 
The minimum connection options that you must specify are your access key id and your access key secret. You can fetch these information at [Aliyun console](https://oss.console.aliyun.com/index#/).
For convenience, OSS SDK uses Dotenv to get access to your ENV variables. So if you set two special environment variables with the value of your access key id and access key secret, 
the SDK will automatically set these options for you. For example, at the root of your project:
 
 ```
   % cat .env
   KEY_ID='XXXXX'
   KEY_SECRET='xxxxxxx'
 ```
 
For Rails Project, you can just add these two variables to `application.yml` or anywhere the `ENV` can access.

See more connection details at Aliyun::OSS::Connection::Management::ClassMethods.

### Clean Up
    
`Base.disconnect` will disconnect the connection if you want.


## Usage

After set up, you can just have fun. The API of the SDK can be read [here](http://github.com)

The three main concepts of OSS are the service, buckets and objects. All files in OSS are stored in buckets 
which act as a top-level container much like a directory. 
All files sent to OSS belong to a bucket and bucket names must be unique across the whole Aliyun OSS system.

### Service 

The service lets you find out general information about your account, like what buckets you have. 

See `Service.buckets` `Service.owner`

### Bucket

Buckets are containers for objects (the files you store on OSS). A single bucket typically stores the files, assets and uploads for an application.

To create a bucket, you can: `Bucket.create('ruby-sdk', 'private', location: 'oss-us-west-1')`

### OSSObject

OSSObjects represent the data you store on OSS. They have a key (their name) and a value (their data). All objects belong to a
bucket.



## Current Status

