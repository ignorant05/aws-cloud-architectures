variable "environment" {
  type = string
}

variable "public_alb_listener_arn" {
  type = string
}

variable "lambda_execution_role_arn" {
  type = string
}

variable "step_functions_role_arn" {
  type = string
}

variable "sre_email" {
  type = string
}
