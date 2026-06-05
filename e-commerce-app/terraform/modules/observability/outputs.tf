output "sns_alert_topic_arn" {
  value       = aws_sns_topic.sre_alerts.arn
  description = "The ARN of the SNS topic for infrastructure alarms"
}

output "cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.app_logs.name
  description = "Log group to pass into your ECS container definitions"
}
