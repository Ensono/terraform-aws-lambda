output "arn" {
  value = aws_lambda_layer_version.layer.arn
}

output "codebuild_role" {
  value = var.github_url != "" ? aws_iam_role.codebuild[0] : null
}
