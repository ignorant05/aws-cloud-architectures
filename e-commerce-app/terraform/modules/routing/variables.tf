variable "vpc_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of all public subnet IDs to associate with the public route table"
}

