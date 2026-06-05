resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.environment}-core-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "HTTP_PROXY"
  integration_uri  = var.public_alb_listener_arn

  integration_method = "ANY"
  connection_type    = "INTERNET"
}

resource "aws_apigatewayv2_route" "routes" {
  for_each  = toset(["GET /search", "GET /product", "POST /cart", "POST /order"])
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

resource "aws_lambda_function" "workflow_tasks" {
  for_each      = toset(["inventory", "shopping", "notification"])
  filename      = "lambda_packages/${each.key}.zip"
  function_name = "${var.environment}-${each.key}-task"
  role          = var.lambda_execution_role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  tracing_config {
    mode = "Active"
  }
}

resource "aws_sns_topic" "order_notifs" {
  name = "${var.environment}-order-notifications-topic"
}

resource "aws_sns_topic_subscription" "sre_email_sub" {
  topic_arn = aws_sns_topic.order_notifs.arn
  protocol  = "email"
  endpoint  = var.sre_email
}

resource "aws_sfn_state_machine" "order_workflow" {
  name     = "${var.environment}-order-processing-workflow"
  role_arn = var.step_functions_role_arn

  definition = <<-EOF
  {
    "Comment": "Orchestrates order tracking systems",
    "StartAt": "CheckInventory",
    "States": {
      "CheckInventory": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.workflow_tasks["inventory"].arn}",
        "Next": "ProcessShopping"
      },
      "ProcessShopping": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.workflow_tasks["shopping"].arn}",
        "Next": "SendNotification"
      },
      "SendNotification": {
        "Type": "Task",
        "Resource": "arn:aws:states:::sns:publish",
        "Parameters": {
          "TopicArn": "${aws_sns_topic.order_notifs.arn}",
          "Message.$": "$.orderDetails"
        },
        "End": true
      }
    }
  }
  EOF
}

resource "aws_cloudwatch_event_bus" "custom_bus" {
  name = "${var.environment}-application-event-bus"
}

resource "aws_cloudwatch_event_rule" "external_sync" {
  name           = "${var.environment}-sync-to-vendors"
  event_bus_name = aws_cloudwatch_event_bus.custom_bus.name
  description    = "Catches completed workflow states and forwards to third-party endpoints"

  event_pattern = jsonencode({
    source      = ["aws.states"]
    detail-type = ["Step Functions Execution Status Change"]
    detail = {
      status = ["SUCCEEDED"]
    }
  })
}
