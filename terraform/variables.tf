variable "function_name" {
  type        = string
  description = "name of lambda function to manage"
}

variable "secret_prod" {
  description = "Name of AWS Secrets resource to load in prod"
}

variable "secret_dev" {
  description = "Name of AWS Secrets resource to load in dev"
}

variable "env_config" {
  type = map(object({
    publish     = bool
    description = string
    alias_name  = string
  }))
  description = "map of workspace env vars"
  default = {
    prod = {
      publish     = true
      description = "prod - secrets"
      alias_name  = "Prod"
    }
    dev = {
      publish     = false
      description = "dev - secrets"
      alias_name  = "Dev"
    }
  }
}
