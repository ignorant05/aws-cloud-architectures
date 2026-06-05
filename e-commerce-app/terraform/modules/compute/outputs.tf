output "public_alb_arn" {
  value = aws_lb.public_alb.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}
