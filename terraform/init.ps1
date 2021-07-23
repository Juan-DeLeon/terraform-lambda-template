$ErrorActionPreference = "Stop"

if (!$args[0]) {
    Write-Output "Missing arg: function_name"
    exit 1
}

$function_name = $args[0]

terraform init
terraform workspace select prod
terraform import aws_lambda_function.func $function_name
terraform import aws_lambda_alias.alias $function_name/Prod
terraform workspace select dev
terraform import aws_lambda_function.func $function_name
terraform import aws_lambda_alias.alias $function_name/Dev
