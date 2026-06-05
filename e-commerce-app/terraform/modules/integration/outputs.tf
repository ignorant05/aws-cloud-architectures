output "api_gateway_domain_name" {
  value       = replace(replace(aws_apigatewayv2_api.http_api.api_endpoint, "https://", ""), "/", "")
  description = "The clean domain name endpoint of the HTTP API Gateway for CloudFront routing"
}

output "workflow_lambda_arns" {
  value = aws_lambda_function.workflow_tasks[*].arn
}
