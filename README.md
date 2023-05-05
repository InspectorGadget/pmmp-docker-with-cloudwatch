# PocketMine-MP logs streamer to AWS CloudWatch

This stack creates a PMMP Game Server and a Sidecar (With CloudWatch Agent installed) to stream game logs to AWS CloudWatch in near real-time #DevOpsWithDocker

## Prerequisites
* Docker
* Docker Compose

## How to use
1. Clone this repository
2. Create an IAM User with the least privilege to access CloudWatch Logs. For more information, refer to this [IAM Policy](./iam-policy.json). 
3. Edit the `aws.conf` file inside the `.awslogs/` folder and replace with your IAM Access Key and IAM Secret Access Key accordingly. 
4. Edit the `docker-compose.yml` file and replace the `AWS_REGION` & `CW_LOG_GROUP_NAME` argument accordingly.
5. Edit the `.aws/aws.conf` file and replace `region`, `aws_access_key_id` & `aws_secret_access_key` accordingly
6. Run `docker-compose up -d` to deploy the stack.
    * Alternatively, you can provide the stack a name by running `docker-compose -p <stack-name> up -d`.

## Teardown
1. Run `docker-compose -p <stack-name> down` to undeploy the stack.

## Have an issue?
Feel free to open an issue if you have any questions or issues.