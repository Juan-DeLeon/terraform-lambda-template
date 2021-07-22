# Terraform AWS Lambda deploy template
Template para hacer deploys en dev / prod de las funciones lambda de originacion y portal de admin

## Init Terraform

Correr script de inicialización.

En Linux:

    ./init.sh <NOMBRE_DE_LAMBDA>

En Windows:

    ./init.ps1 <NOMBRE_DE_LAMBDA>

## Deploy dev

    terraform workspace select dev
    terraform apply
    yes

## Deploy prod

    terraform workspace select prod
    terraform apply
    yes

| :exclamation:  Deploys a prod cambian las variables de ambiente en $LATEST. |
|-----------------------------------------|
