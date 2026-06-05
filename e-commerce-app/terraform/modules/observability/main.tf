resource "aws_xray_encryption_config" "xray" {
  type = "NONE"
}

resource "aws_sns_topic" "sre_alerts" {
  name = "${var.environment}-sre-alerts-topic"
}

resource "aws_sns_topic_subscription" "sre_email_sub" {
  topic_arn = aws_sns_topic.sre_alerts.arn
  protocol  = "email"
  endpoint  = var.sre_email_address
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.environment}-ecs-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = var.ecs_cluster_name
  }

  alarm_description = "This metric monitors ECS cluster CPU utilization. If it exceeds 80%, fire an alert to SRE team."
  alarm_actions     = [aws_sns_topic.sre_alerts.arn]
  ok_actions        = [aws_sns_topic.sre_alerts.arn]
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ecs/${var.environment}-container-services"
  retention_in_days = var.log_retention_days
}
