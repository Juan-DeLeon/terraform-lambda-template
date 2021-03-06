provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

# Create an archive form the Lambda source code,
# filtering out unneeded files.
data "archive_file" "lambda_source_package" {
  type        = "zip"
  source_dir  = "../src/"
  output_path = "../function.zip"
}

data "aws_lambda_function" "f_data" {
  function_name = var.function_name
}

locals {
  # load env config for current workspace
  env           = lookup(var.env_config, terraform.workspace)
  secret_name   = (terraform.workspace == "prod") ? var.secret_prod : var.secret_dev
  function_data = data.aws_lambda_function.f_data
  alias_version = (terraform.workspace == "prod") ? aws_lambda_function.func.version : "$LATEST"
}

# Deploy the Lambda function to AWS
resource "aws_lambda_function" "func" {
  function_name    = local.function_data.function_name
  description      = local.env.description
  filename         = data.archive_file.lambda_source_package.output_path
  handler          = local.function_data.handler
  runtime          = local.function_data.runtime
  role             = local.function_data.role
  publish          = local.env.publish
  source_code_hash = filebase64sha256(data.archive_file.lambda_source_package.output_path)
  environment {
    variables = {
      SECRET_NAME = local.secret_name
    }
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [layers, timeout, tags]
  }
}

resource "aws_lambda_alias" "alias" {
  name             = local.env.alias_name
  description      = "${local.env.alias_name} deploy from terraform"
  function_name    = aws_lambda_function.func.arn
  function_version = local.alias_version
}
