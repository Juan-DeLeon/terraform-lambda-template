$ErrorActionPreference = "Stop"

if (!$args[0]) {
    Write-Output "Missing arg: function_name"
    exit 1
}

terraform init
terraform workspace select prod
terraform import aws_lambda_function.func $args[0]
terraform import aws_lambda_alias.alias $args[0]/Prod
terraform workspace select dev
terraform import aws_lambda_function.func $args[0]
terraform import aws_lambda_alias.alias $args[0]/Dev
