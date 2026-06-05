output "public_alb_sg_id" {
  value = aws_security_group.public_alb.id
}

output "ecs_tasks_sg_id" {
  value = aws_security_group.ecs_tasks.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "redis_sg_id" {
  value = aws_security_group.redis_elasticache.id
}

output "pci_sg_id" {
  value = aws_security_group.pci_scoped.id
}

output "search_sg_id" {
  value = aws_security_group.search.id
}

output "analytics_sg_id" {
  value = aws_security_group.analytics.id
}

output "ecs_exec_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "step_functions_role_arn" {
  value = aws_iam_role.step_functions_role.arn
}

output "worker_sg_id" {
  value = aws_security_group.worker_sg.id
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
