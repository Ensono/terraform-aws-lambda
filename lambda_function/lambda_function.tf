resource "aws_lambda_function" "lambda" {
  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  runtime                        = var.runtime
  filename                       = var.create_empty_function ? "${path.module}/placeholder.zip" : var.filename
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish
  layers                         = var.layers

  vpc_config {
    subnet_ids         = var.vpc_config["subnet_ids"]
    security_group_ids = var.vpc_config["security_group_ids"]
  }

  environment {
    variables = var.environment_variables
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
}
