# mr-vercetti/tf-aws-demo
Simple demo of using Terraform in an AWS environment created for learning purposes.

## Used AWS services
* [S3](https://aws.amazon.com/s3/)
* [DynamoDB](https://aws.amazon.com/dynamodb/)
* [VPC](https://aws.amazon.com/vpc/)
* [EC2](https://aws.amazon.com/ec2/)
* [Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/application-load-balancer/)

## Operation
This terraform configuration creates VPC and public and private networks with Internet access via IGW and NAT Gateway. A bastion host is created in one of the public networks, from which we can access an autoscaling group of EC2 instances located in the private network. The group hosts a simple web application and scales according to CPU usage. In front of the application is an ALB that directs traffic appropriately. The main infrastructure configuration uses the S3 remote backend with DynamoDB state locking.

## Usage
### Prerequirements
* EC2 key pair created in AWS console

### Infra setup
1. Complete terraform.tfvars files (`./backend/terraform.tfvars` and `./prod/terraform.tfvars`)
2. Initialize and apply terraform config from the `backend` dir. This will create an S3 bucket and DynamoDB table to use remote state.
3. Complete backend block in `prod/versions.tf` with the data you saw in the output from the previous step.
4. Initialize and apply terraform config from the `prod` dir. This will create the rest of infrastructure.

## Future work
[x] Move state to S3 bucket and create state locking via DynamoDB