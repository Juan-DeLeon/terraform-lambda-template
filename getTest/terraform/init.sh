#!/bin/bash -e
if [ $# -eq 0 ]; then
    echo "Missing arg: function_name"
    exit 1
fi

terraform init
terraform workspace select prod
terraform import aws_lambda_function.func $1
terraform import aws_lambda_alias.alias $1/Prod
terraform workspace select dev
terraform import aws_lambda_function.func $1
terraform import aws_lambda_alias.alias $1/Dev
