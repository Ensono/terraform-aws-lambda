output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "role" {
  value = aws_iam_role.lambda
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "codebuild_role" {
  value = aws_iam_role.codebuild
}
