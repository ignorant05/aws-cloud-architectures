variable "environment" {
  type        = string
  description = "Target environment name (e.g., prod, dev)"
}

variable "vpc_id" {
  type        = string
  description = "The target VPC ID where security groups will deploy"
}

variable "vpc_cidr_block" {
  type = string
}

variable "payment_processor_cidr" {
  type = string
}

