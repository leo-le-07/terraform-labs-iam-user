terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-labs-backend-et9kziex"
    key = "iam-user/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

resource "aws_iam_user" "numbered_users" {
  count = 3
  name  = "test-user-${count.index + 1}"  # Creates test-user-1, test-user-2, test-user-3

  tags = {
    Environment = "Test"
    CreatedBy   = "Terraform"
    UserNumber  = count.index + 1
  }
}

resource "aws_security_group" "prod_sg" {
  name = "prod-sg"

  tags = {
    Environment = "Test"
    CreatedBy   = "Terraform"
  }
}

output "numbered_users" {
  value = aws_iam_user.numbered_users[*].arn
}

output "prod_sg" {
  value = aws_security_group.prod_sg.arn
}