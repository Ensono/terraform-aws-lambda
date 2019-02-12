module "schedule_trigger" {
  source = "../../lambda_function"

  function_name         = "tf-example-lambda-schedule"
  description           = "example lambda triggered by schedule"
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
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketVersions",
      ]

      Resource = [
        "arn:aws:s3:::*",
      ]
    },
  ]

  trigger_schedule = {
    enabled             = true
    schedule_expression = "rate(1 hour)"
  }
}
