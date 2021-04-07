data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "codebuild" {
  count = var.github_url == "" ? 0 : 1

  name = "codebuild_${var.function_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild" {
  count = var.github_url == "" ? 0 : 1
  role = aws_iam_role.codebuild[0].name
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"]
  }
  statement {
    effect = "Allow"
    resources = [
      aws_lambda_function.lambda.arn]
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:ListVersionsByFunction",
      "lambda:UpdateAlias"
    ]
  }
  dynamic "statement" {
    for_each = var.codebuild_can_run_integration_test ? ["allow_invoke"] : []
    content {
      effect = "Allow"
      resources = [aws_lambda_function.lambda.arn]
      actions = ["lambda:InvokeFunction", "lambda:GetFunctionConfiguration"]
    }
  }

}

resource "aws_codebuild_project" "lambda" {
  count = var.github_url == "" ? 0 : 1

  name          = var.function_name
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "run_integration_test"
      value = var.codebuild_can_run_integration_test
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_url
    git_clone_depth = 1

    auth {
      type     = "OAUTH"
      resource = var.codebuild_credential_arn == "" ? "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:token/github" : var.codebuild_credential_arn
    }
  }
}

resource "aws_codebuild_webhook" "lambda" {
  count = var.github_url == "" ? 0 : 1

  project_name = aws_codebuild_project.lambda[0].name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.git_branch
    }
  }
}
