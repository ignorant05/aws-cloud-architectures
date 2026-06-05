variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "data_subnet_ids" {
  type = list(string)
}

variable "analytics_subnet_ids" {
  type = list(string)
}

variable "search_security_group_id" {
  type = string
}

variable "analytics_security_group_id" {
  type = string
}

variable "firehose_iam_role_arn" {
  type = string
}

variable "glue_iam_role_arn" {
  type = string
}

variable "kinesis_shard_count" {
  default = 1
}

variable "opensearch_instance_type" {
  default = "t3.small.search"
}

variable "redshift_admin_username" {
  type = string
}

variable "redshift_admin_password" {
  type      = string
  sensitive = true
}
