$ErrorActionPreference = "Stop"

if (!$args[0]) {
    Write-Output "Missing arg: environment"
    exit 1
}

if ( $args[0] -eq "dev" ){
    terraform workspace select dev
    terraform apply -auto-approve
}
elseif ( $args[0] -eq "prod" ) {
    terraform workspace select prod
    terraform apply
    if ($LastExitCode -eq 1) { exit 1 }
    terraform workspace select dev
    terraform apply -auto-approve
}
else {
    echo "env '$args[0]' not defined"
    exit 1
}
