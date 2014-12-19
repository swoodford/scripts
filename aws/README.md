aws
=======

A collection of shell scripts meant to be run in OS X for performing various tasks with AWS

- **create-cloudwatch-alarms.sh** Create AWS CloudWatch alarms for EC2, RDS, Load Balancer environments
- **ec2-create-snapshots.sh** Create a snapshot of each EC2 volume that is tagged with the backup flag
- **ec2-delete-snapshots.sh** Deletes snapshots for each EC2 volume that is tagged with the backup flag and matches the specified date
- **ec2-import-network-acl.sh** Import CIDR IP list to AWS VPC ACL rule and deny access
- **s3-buckets-file-size.sh** Count total size of all data stored in all S3 buckets