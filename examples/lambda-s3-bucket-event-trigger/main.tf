resource "aws_s3_bucket" "example" {
  bucket = "tf-example-lambda-s3-trigger"
  acl    = "private"
}

module "lambda_s3_trigger" {
  source = "../../lambda_function"

  function_name         = "tf-example-lambda-s3-trigger"
  description           = "example lambda triggered by s3 bucket event"
  runtime               = "python3.7"
  handler               = "index.lambda_handler"
  create_empty_function = true

  environment_variables = {
    var1 = "test"
  }

  timeout     = 30
  memory_size = 128

  policies = [
    {
      Effect = "Allow"

      Action = [
        "s3:Get*",
      ]

      Resource = [
        "arn:aws:s3:::${aws_s3_bucket.example.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.example.bucket}/*",
      ]
    },
  ]

  bucket_trigger = {
    enabled = true
    bucket  = "${aws_s3_bucket.example.bucket}"
    filter_prefix  = "images/"
    filter_suffix  = null
  }

  permissions = {
    enabled      = true
    statement_id = "AllowExecutionFromS3Bucket"
    action       = "lambda:InvokeFunction"
    principal    = "s3.amazonaws.com"
    source_arn   = "arn:aws:s3:::${aws_s3_bucket.example.bucket}"
  }
}
