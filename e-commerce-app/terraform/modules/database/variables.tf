variable "environment" {
  type = string
}

variable "data_subnet_ids" {
  type = list(string)
}

variable "db_security_group_id" {
  type = string
}

variable "cache_security_group_id" {
  type = string
}

variable "rds_instance_class" {
  default = "db.t4g.medium"
}

variable "db_name" {
  default = "ecommerce"
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

variable "redis_node_type" {
  default = "cache.t4g.small"
}
