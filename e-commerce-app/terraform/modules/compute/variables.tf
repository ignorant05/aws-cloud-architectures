variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "pci_subnet_ids" {
  type = list(string)
}

variable "public_alb_sg_id" {
  type = string
}

variable "ecs_tasks_sg_id" {
  type = string
}

variable "worker_sg_id" {
  type = string
}

variable "ecs_exec_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "container_registry_url" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  default = "t3.medium"
}
