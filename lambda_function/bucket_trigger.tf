resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = "${var.bucket_trigger["enabled"] ? 1 : 0}"
  bucket = "${var.bucket_trigger["bucket"]}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}
