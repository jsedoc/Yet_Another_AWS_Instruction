# Yet_Another_AWS_Instruction
There are too many repositories about this, so I decided to add my own.


I've posted two youtube videos for starting your AWS instance. Hopefully they are helpful.

 
Here's the links to the videos

[part 1](https://youtu.be/fQbL8nxXdWs)

[part 2](https://youtu.be/4wH-MCSfY58)

I'd recommend watching at 1.5 or 2 times speed ;)

There are two important scripts: 

    1. attach_volumes.sh which mounts the volumes on the instances.
    1. start_instance.sh which :
         * starts the ec2 instance 
         * attaches elastic IP
         * associates volumes
         * mounts the EFS partition
         * mounts S3 buckets

The scripts start script requires the [AWS command line interface](https://aws.amazon.com/cli/).

To mount the S3 bucket you also need your [AWS access key](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys).
