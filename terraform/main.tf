provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
provider "archive" {}

terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "env_config" {
  type = map
  default = {
    prod = {
      publish = true
      secret_name = "ConexionBDLambdas_OriginacionDigital_Prod"
      description = "prod deploy"
    }
    dev = {
      publish = false
      secret_name = "ConexionBDLambdas_OriginacionDigital"
      description = "dev"
    }
  }
}

locals {
  env = lookup(var.env_config, terraform.workspace)
}

# Create an archive form the Lambda source code,
# filtering out unneeded files.
data "archive_file" "lambda_source_package" {
  type        = "zip"
  source_dir  = "../src/"
  output_path = "../test.zip"
}

# Deploy the Lambda function to AWS
resource "aws_lambda_function" "test" {
  function_name = "test"
  description   = local.env.description
  filename      = data.archive_file.lambda_source_package.output_path
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = "arn:aws:iam::943176671807:role/lambda-role"
  publish       = local.env.publish
  environment {
    variables = {
      SECRET_NAME = local.env.secret_name
    }
  }
  lifecycle {
    ignore_changes = [layers, timeout]
  }
}

resource "aws_lambda_alias" "prod" {
  count = (terraform.workspace == "prod") ? 1 : 0
  name             = "Prod"
  description      = "prod alias from terraform"
  function_name    = aws_lambda_function.test.arn
  function_version = aws_lambda_function.test.version
}
