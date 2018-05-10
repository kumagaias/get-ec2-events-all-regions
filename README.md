# Get EC2 Events All Regions Easily

## Require
- [aws cli](https://aws.amazon.com/cli/)
- [aws credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
- [jq v1.5 later](https://stedolan.github.io/jq/download/)

## Set up AWS Credentials Example

~~~bash
$ aws configure --profile example_profile1
$ aws configure --profile example_profile2
~~~

## Usage

~~~bash
$ ./get-ec2-events-all-regions.sh
~~~

## Sample

~~~bash
$ ./get-ec2-events-all-regions.sh
----- profile example_profile1 -----
checking ap-south-1
checking eu-west-3
checking eu-west-2
checking eu-west-1
checking ap-northeast-2
checking ap-northeast-1
checking sa-east-1
checking ca-central-1
checking ap-southeast-1
checking ap-southeast-2
checking eu-central-1
checking us-east-1
checking us-east-2
checking us-west-1
checking us-west-2
----- profile example_profile2-----
checking ap-south-1
checking eu-west-3
checking eu-west-2
checking eu-west-1
checking ap-northeast-2
checking ap-northeast-1
checking sa-east-1
checking ca-central-1
checking ap-southeast-1
checking ap-southeast-2
checking eu-central-1
checking us-east-1
checking us-east-2
checking us-west-1
checking us-west-2
Completed! Check 20180510_112211_ec2_events.csv
~~~
