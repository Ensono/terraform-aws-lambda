output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "role" {
  value = aws_iam_role.lambda
}