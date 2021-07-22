# Terraform AWS Lambda deploy template
Template para hacer deploys en dev / prod de las funciones lambda de originacion y portal de admin.

**Todos los scripts se corren desde la carpeta de `terraform/`.**

## Init Terraform

Correr script de inicialización.

Linux:

    ./init.sh <NOMBRE_DE_LAMBDA>

Windows:

    ./init.ps1 <NOMBRE_DE_LAMBDA>

## Deploy dev

### Manualmente

    terraform workspace select dev
    terraform apply
    yes

### Script

Linux:

    ./deploy.sh dev

Windows:

    ./deploy.ps1 dev

## Deploy prod

### Manualmente

    terraform workspace select prod
    terraform apply
    yes

| :exclamation: Deploys a `Prod` cambian las variables de entorno en `$LATEST`. |
|----------------------------------------------------------------------------|

### Script

Linux:

    ./deploy.sh prod

Windows:

    ./deploy.ps1 prod

| :heavy_check_mark: El script hace un deploy a `Prod` y después a `Dev` para regresar las variables de entorno en `$LATEST` a dev. |
|----------------------------------------------------------------------------|