output "arn" {
  value = aws_lambda_layer_version.layer.arn
}

output "codebuild_role" {
  value = aws_iam_role.codebuild
}
