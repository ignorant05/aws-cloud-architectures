variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "primary_domain_name" {
  type = string
}

variable "domain_aliases" {
  type = list(string)
}

variable "acm_certificate_arn" {
  type = string
}

variable "api_gateway_domain_name" {
  type = string
}

