Amazon S3 is cloud storage for the Internet. To upload your data (photos, videos, documents etc.), you first create a bucket in one of the AWS regions. You can then upload any number of objects to the bucket.

In terms of implementation, buckets and objects are resources, and Amazon S3 provides APIs for you to manage them. For example, you can create a bucket and upload objects using the Amazon S3 API. You can also use the Amazon S3 console to perform these operations. The console internally uses the Amazon S3 APIs to send requests to Amazon S3.

In this section, we explain working with buckets. For information about working with objects, see Working with Amazon S3 Objects.

Amazon S3 bucket names are globally unique, regardless of the AWS region in which you create the bucket. You specify the name at the time you create the bucket. For bucket naming guidelines, see Bucket Restrictions and Limitations.

Amazon S3 creates bucket in a region you specify. You can choose any AWS region that is geographically close to you to optimize latency, minimize costs, or address regulatory requirements. For example, if you reside in Europe, you might find it advantageous to create buckets in the EU (Ireland) or EU (Frankfurt) regions. For a list of AWS Amazon S3 regions, go to Regions and Endpoints in the AWS General Reference.

Note
Objects belonging to a bucket that you create in a specific AWS region never leave that region, unless you explicitly transfer them to another region. For example, objects stored in the EU (Ireland) region never leave it.
Creating a Bucket

Amazon S3 provides APIs for you to create and manage buckets. By default, you can create up to 100 buckets in each of your AWS accounts. If you need additional buckets, you can increase your bucket limit by submitting a service limit increase. To learn more about submitting a bucket limit increase, go to AWS Service Limits in the AWS General Reference.

When you create a bucket, you provide a name and AWS region where you want the bucket created. The next section (see Accessing a Bucket) discusses DNS-compliant bucket names.

Within each bucket, you can store any number of objects. You can create a bucket using any of the following methods:

Create the bucket using the console.
Create the bucket programmatically using the AWS SDKs.
Note
If you need to, you can also make the Amazon S3 REST API calls directly from your code. However, this can be cumbersome because it requires you to write code to authenticate your requests. For more information, go to PUT Bucket in the Amazon Simple Storage Service API Reference.
When using AWS SDKs you first create a client and then send a request to create a bucket using the client.  You can specify an AWS region when you create the client (US Standard is the default region). You can also specify a region in your create bucket request.  Note the following:
If you create a client by specifying the US Standard region, it uses the following endpoint to communicate with Amazon S3.
s3.amazonaws.com
You can use this client to create a bucket in any AWS region. In your create bucket request,
If you don’t specify a region, Amazon S3 creates the bucket in the US Standard region.
If you specify an AWS region, Amazon S3 creates the bucket in the specified region.
If you create a client by specifying any other AWS region, each of these regions maps to the region-specific endpoint:
s3-<region>.amazonaws.com
For example, if you create a client by specifying the eu-west-1 region, it maps to the following region-specific endpoint:
s3-eu-west-1.amazonaws.com
In this case, you can use the client to create a bucket only in the eu-west-1 region. Amazon S3 returns an error if you specify any other region in your create bucket request.
For a list of available AWS regions, go to Regions and Endpoints in the AWS General Reference.
For examples, see Examples of Creating a Bucket.

About Permissions

You can use your AWS account root credentials to create a bucket and perform any other Amazon S3 operation. However, AWS recommends not using the root credentials of your AWS account to make requests such as create a bucket. Instead, create an IAM user, and grant that user full access (users by default have no permissions). We refer to these users as administrator users. You can use the administrator user credentials, instead of the root credentials of your account, to interact with AWS and perform tasks, such as create a bucket, create users, and grant them permissions.

For more information, go to Root Account Credentials vs. IAM User Credentials in the AWS General Reference and IAM Best Practices in Using IAM.

The AWS account that creates a resource owns that resource. For example, if you create an IAM user in your AWS account and grant the user permission to create a bucket, the user can create a bucket. But the user does not own the bucket; the AWS account to which the user belongs owns the bucket. The user will need additional permission from the resource owner to perform any other bucket operations. For more information about managing permissions for your Amazon S3 resources, see Managing Access Permissions to Your Amazon S3 Resources.

Accessing a Bucket

You can access your bucket using the Amazon S3 console. Using the console UI, you can perform almost all bucket operations without having to write any code.

If you access a bucket programmatically, note that Amazon S3 supports RESTful architecture in which your buckets and objects are resources, each with a resource URI that uniquely identify the resource.

Amazon S3 supports both virtual-hosted–style and path-style URLs to access a bucket.

In a virtual-hosted–style URL, the bucket name is part of the domain name in the URL. For example:  
http://bucket.s3.amazonaws.com
http://bucket.s3-aws-region.amazonaws.com.
In a virtual-hosted–style URL, you can use either of these endpoints. If you make a request to the http://bucket.s3.amazonaws.com endpoint, the DNS has sufficient information to route your request directly to the region where your bucket resides.
In a path-style URL, the bucket name is not part of the domain (unless you use a region-specific endpoint). For example:
US Standard endpoint, http://s3.amazonaws.com/bucket
Region-specific endpoint, http://s3-aws-region.amazonaws.com/bucket
In a path-style URL, the endpoint you use must match the region in which the bucket resides. For example, if your bucket is in the South America (Sao Paulo) region, you must use the http://s3-sa-east-1.amazonaws.com/bucket endpoint. If your bucket is in the US Standard region, you must use the http://s3.amazonaws.com/bucket endpoint.
Important
Because buckets can be accessed using path-style and virtual-hosted–style URLs, we recommend you create buckets with DNS-compliant bucket names. For more information, see Bucket Restrictions and Limitations.
For more information, see Virtual Hosting of Buckets.

Bucket Configuration Options

Amazon S3 supports various options for you to configure your bucket. For example, you can configure your bucket for website hosting, add configuration to manage lifecycle of objects in the bucket, and configure the bucket to log all access to the bucket. Amazon S3 supports subresources for you store, and manage the bucket configuration information. That is, using the Amazon S3 API, you can create and manage these subresources. You can also use the console or the AWS SDKs.

Note
There are also object-level configurations. For example, you can configure object-level permissions by configuring an access control list (ACL) specific to that object.
These are referred to as subresources because they exist in the context of a specific bucket or object. The following table lists subresources that enable you to manage bucket-specific configurations.