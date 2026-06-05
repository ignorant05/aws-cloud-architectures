variable "environment" {
  type = string
}

variable "sre_email_address" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "log_retention_days" {
  default = 30
}
