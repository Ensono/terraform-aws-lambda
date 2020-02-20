# Process events from SQS queue, DynamoDB, Kinesis
resource "aws_lambda_event_source_mapping" "lambda" {
  count            = length(var.source_mappings)
  batch_size       = lookup(var.source_mappings[count.index], "batch_size")
  event_source_arn = lookup(var.source_mappings[count.index], "event_source_arn")
  enabled          = lookup(var.source_mappings[count.index], "enabled")
  function_name    = aws_lambda_function.lambda.arn
}
