[![Build Status](https://travis-ci.org/42thcoder/oss-ruby-sdk.svg?branch=master)](https://travis-ci.org/42thcoder/oss-ruby-sdk)

[![Coverage Status](https://coveralls.io/repos/42thcoder/oss-ruby-sdk/badge.svg?branch=master&service=github)](https://coveralls.io/github/42thcoder/oss-ruby-sdk?branch=master)

[![Code Climate](https://codeclimate.com/github/42thcoder/oss-ruby-sdk/badges/gpa.svg)](https://codeclimate.com/github/42thcoder/oss-ruby-sdk)

[![Test Coverage](https://codeclimate.com/github/42thcoder/oss-ruby-sdk/badges/coverage.svg)](https://codeclimate.com/github/42thcoder/oss-ruby-sdk/coverage)

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

The three main concepts of OSS are the service, buckets and objects. 

### Service 

The service lets you find out general information about your account, like what buckets you have. 

See `Service.buckets` `Service.owner`

### Bucket

Buckets are containers for objects (the files you store on OSS). 

You can create bucket: `Bucket.create('test')`. And of course, you can then fetch this bucket, 
`Bucket.find('test')`. If you are unhappy of some config of the bucket, you may update it!

```ruby
Bucket.update_lifecycle('test', [{prefix: 'test', status: 'Enabled', days: 1}])
Bucket.update_acl('test', 'private')
```

At last, you can remove unwanted bucket with one simple code: `Bucket.delete('test')`


### OSSObject

OSSObjects represent the data you store on OSS. They have a key (their name) and a value (their data). All objects belong to a
bucket.

The functions of Object is almost as same as Bucket. Here are some demo codes.

```ruby
OSSObject.create('test.jpg', 'bucket_name')
OSSObject.find('test.jpg', 'bucket_name')
OSSObject.meta('test.jpg', 'bucket_name')
```


If you want to access full API description, go ahead to visit [doc](http://www.rubydoc.info/)


## Current Status

See docs/KnownBugs to get more infomation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/oss-sdk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
