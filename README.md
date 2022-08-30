# mr-vercetti/tf-aws-demo
Simple demo of using Terraform in an AWS environment created for learning purposes.

## Used AWS services
* [VPC](https://aws.amazon.com/vpc/)
* [EC2](https://aws.amazon.com/ec2/)
* [Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/application-load-balancer/)

## Operation
This terraform configuration creates VPC and public and private networks with Internet access via IGW and NAT Gateway. A bastion host is created in one of the public networks, from which we can access an autoscaling group of EC2 instances located in the private network. The group hosts a simple web application and scales according to CPU usage. In front of the application is an ALB that directs traffic appropriately.

## Prerequirements
* EC2 key pair created
* Completed terraform.tfvars file

## Future work
* Move state to S3 bucket and create state locking via DynamoDB