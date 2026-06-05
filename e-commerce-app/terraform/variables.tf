variable "region" {
  default = "us-east-1"
  type    = string
}

variable "cluster_name" {
  default = "ecommerce"
  type    = string
}

variable "environment" {
  default = "production"
  type    = string
}

variable "aws_account_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "redis_auth_token" {
  type      = string
  sensitive = true
}

variable "worker_ami_id" {
  type = string
}

variable "awsadmin" {
  type = string
}

variable "secret_redshift_pass" {
  type      = string
  sensitive = true
}

variable "sre_email" {
  type = string
}

variable "payment_processor_cidr" {
  type = string
}
