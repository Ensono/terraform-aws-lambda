resource "aws_cloudwatch_event_rule" "lambda" {
  count = "${var.trigger_schedule["enabled"] ? 1 : 0}"

  name                = "${var.function_name}-schedule"
  description         = "Schedule - ${var.trigger_schedule["schedule_expression"]}"
  schedule_expression = "${var.trigger_schedule["schedule_expression"]}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = "${var.trigger_schedule["enabled"] ? 1 : 0}"

  rule      = "${aws_cloudwatch_event_rule.lambda[0].name}"
  target_id = "${var.function_name}-target"
  arn       = "${aws_lambda_function.lambda.arn}"
}

resource "aws_lambda_permission" "lambda_cloudwatch" {
  count = "${var.trigger_schedule["enabled"] ? 1 : 0}"

  statement_id  = "${var.function_name}-permission"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda[0].arn}"
}
