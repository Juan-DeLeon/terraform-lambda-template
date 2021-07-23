#!/bin/bash -e

if [ $# -eq 0 ]; then
    echo "Missing arg: environment"
    exit 1
fi

if [[ $1 == "dev" ]]; then
    terraform workspace select dev
    terraform apply -auto-approve
elif [[ $1 == "prod" ]]; then
    terraform workspace select prod
    terraform apply
    terraform workspace select dev
    terraform apply -auto-approve
else
    echo "env '$1' not defined"
    exit 1
fi
