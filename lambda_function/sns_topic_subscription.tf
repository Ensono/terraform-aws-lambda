# SNS
resource "aws_sns_topic_subscription" "lambda" {
  count     = var.sns_topic_subscription["enabled"] ? 1 : 0
  topic_arn = lookup(var.sns_topic_subscription, "sns_topic_arn")
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "lambda_sns" {
  count = var.sns_topic_subscription["enabled"] ? 1 : 0

  statement_id  = "AllowExecutionFromSNS-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = lookup(var.sns_topic_subscription, "sns_topic_arn")
}
