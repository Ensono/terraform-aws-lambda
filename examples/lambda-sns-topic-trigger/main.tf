resource "aws_sns_topic" "example" {
  name = "example"
}

module "sns_trigger" {
  source = "../../lambda_function"

  function_name         = "tf-example-lambda-sns-trigger"
  description           = "example lambda triggered by sns topic event"
  runtime               = "python3.7"
  handler               = "index.lambda_handler"
  create_empty_function = true

  environment_variables = {
    var1 = "test"
  }

  timeout     = 30
  memory_size = 128

  policies = []

  sns_topic_subscription = {
    enabled       = true
    sns_topic_arn = "${aws_sns_topic.example.arn}"
  }
}
