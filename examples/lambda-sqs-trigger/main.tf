resource "aws_sqs_queue" "lambda_example" {
  name = "tf-example-lambda-sqs-trigger"
}

locals {
  arn = "${aws_sqs_queue.lambda_example.arn}"
}

module "sqs_trigger" {
  source = "../../lambda_function"

  function_name         = "tf-example-lambda-sqs-trigger"
  description           = "example lambda triggered by sqs queue"
  runtime               = "java8"
  handler               = "example.Hello::handleRequest"
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
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
      ]

      Resource = [
        "arn:aws:sqs:eu-west-1:060026223997:${aws_sqs_queue.lambda_example.name}",
      ]
    },
  ]

  source_mappings = [
    {
      enabled          = true
      event_source_arn = "arn:aws:sqs:eu-west-1:060026223997:${aws_sqs_queue.lambda_example.name}"
      batch_size       = 10
    },
  ]
}
