#!/bin/bash -e
# add module / function_name here
modules=("test" "getTest")

envs=("prod" "dev")
lambda_alias=("Prod", "Dev")

terraform init

for env in "${envs[@]}"
do
    :
    terraform workspace select $env

    for module in "${modules[@]}"
    do
        :
        terraform import module.$module.aws_lambda_function.func $module
        terraform import module.$module.aws_lambda_alias.alias $module/${env^}
    done

done
