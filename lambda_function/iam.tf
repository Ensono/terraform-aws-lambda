resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "local_file" "debug_policy" {
  count    = 0
  filename = "${path.module}/policy/${var.function_name}.json"

  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": ${jsonencode(var.policies)}
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  count = length(var.policies) == 0 ? 0 : 1
  name  = "${var.function_name}-lambda-policy"
  role  = aws_iam_role.lambda.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": ${jsonencode(var.policies)}
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
