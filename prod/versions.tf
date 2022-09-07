terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }

  backend "s3" {
    bucket         = "demo-state-bucket-98017casd"
    key            = "tf-aws-demo/prod/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    kms_key_id     = "9bb018d4-3ef8-496e-884c-154478d7f8b2"
    dynamodb_table = "demo-state-lock"
  }
}