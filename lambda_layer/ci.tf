data "aws_ssm_parameter" "github_token" {
  name = var.github_token_ssm_param
}

resource "aws_codebuild_source_credential" "github_token" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github_token.value
}

resource "aws_iam_role" "codebuild" {
  name = "codebuild_${var.layer_name}"

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
  role = aws_iam_role.codebuild.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "${aws_lambda_layer_version.layer.layer_arn}",
      "Action": "lambda:PublishLayerVersion"
    }
  ]
}
EOF
}

resource "aws_codebuild_project" "lambda" {
  name          = var.layer_name
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = var.github_url
    git_clone_depth = 1

    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.github_token.arn
    }
  }
}

resource "aws_codebuild_webhook" "lambda" {
  project_name = aws_codebuild_project.lambda.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}
