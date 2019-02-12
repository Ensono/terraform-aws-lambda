resource "aws_lambda_permission" "permission" {
  count         = "${var.permissions["enabled"] ? 1 : 0}"
  statement_id  = "${var.permissions["statement_id"]}"
  action        = "${var.permissions["action"]}"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "${var.permissions["principal"]}"
  source_arn    = "${var.permissions["source_arn"]}"
}
