# Locations

You can choose which data center, aka location, your buckets and objects would be saved at.

## Options

Currently, Aliyun has the locations listed below:

- oss-cn-hangzhou
- oss-cn-qingdao
- oss-cn-beijing 
- oss-cn-hongkong 
- oss-cn-shenzhen 
- oss-cn-shanghai 
- oss-us-west-1 
- oss-ap-southeast-1

The default location is `oss-cn-hangzhou`. You can override this by using `location` options. For example:

```ruby
Bucket.create('ruby-test', location: 'oss-us-west-1')
```

And then your bucket will be created at `oss-us-west-1`.

So does the object.

## Notice

Choose the location which is closest to your customers so they can achieve the highest speed.

To emphasize, you can not change location of the existing bucket. So, choose wisely~

