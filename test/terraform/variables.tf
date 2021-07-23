variable "function_name" {
  type = string
  description = "name of lambda function to manage"
}

variable "env_config" {
  type = map
  description = "map of workspace env vars"
  default = {
    prod = {
      publish = true
      secret_name = "ConexionBDLambdas_OriginacionDigital_Prod"
      description = "prod - secrets"
      alias_name = "Prod"
    }
    dev = {
      publish = false
      secret_name = "ConexionBDLambdas_OriginacionDigital"
      description = "dev - secrets"
      alias_name = "Dev"
    }
  }
}

