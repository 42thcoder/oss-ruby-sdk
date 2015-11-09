# Multipart Upload


## Introduction

The Multipart upload API enables you to upload large objects in parts. You can use this API to upload new large objects or make a copy of an existing object.

## Usage


### Multipart Upload Initiation

```ruby
 MultipartUpload.initiate('2624.jpg', 'ruby-sdk')
```

This will return the upload ID, which is a unique identifier for your multipart upload.
You must include this upload ID whenever you upload parts, list the parts, complete an upload, or abort an upload. 
If you want to provide any metadata describing the object being uploaded, you must provide it in the request to initiate multipart upload.


### Parts Upload

```ruby
upload_id = MultipartUpload.initiate('2621.jpg', 'ruby-sdk')[:initiate_multipart_upload_result][:upload_id]
MultipartUpload.store('2621.jpg', 'ruby-sdk', 1, upload_id, File.read('6764.jpg'))
```

When uploading a part, in addition to the upload ID, you must specify a part number. 
You can choose any part number between 1 and 10,000. A part number uniquely identifies a part and 
its position in the object you are uploading. If you upload a new part using the same part number as a previously 
uploaded part, the previously uploaded part is overwritten.
Whenever you upload a part, Aliyun OSS returns an ETag header in its response. 
For each part upload, you must record the part number and the ETag value. 
You need to include these values in the subsequent request to complete the multipart upload.


### Multipart Upload Listings

You can list the parts of a specific multipart upload or all in-progress multipart uploads. 

```ruby
MultipartUpload.all(bucket)[:list_multipart_uploads_result]
```


### Finish Multipart Upload 

You may finish multipart upload after you upload all the parts, like: 

```ruby
      object = '2622.jpg'
      bucket = 'ruby-sdk'
      upload_id = MultipartUpload.initiate(object, bucket)[:initiate_multipart_upload_result][:upload_id]
      parts     = [MultipartUpload.store(object, bucket, 1, upload_id, File.read('6764.jpg'))]
      mu = MultipartUpload.finish(object, bucket, upload_id, parts)
```

### Abort Multipart Upload 

You may finish multipart upload if you don't want to upload any parts, like: 

```ruby
      object = '2623.jpg'
      bucket = 'ruby-sdk'
      upload_id = MultipartUpload.initiate(object, bucket)[:initiate_multipart_upload_result][:upload_id]
      MultipartUpload.store(object, bucket, 1, upload_id, File.read('6764.jpg'))
      mu = MultipartUpload.abort(object, bucket, upload_id)
```


