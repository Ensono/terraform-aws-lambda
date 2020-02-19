data "aws_ssm_parameter" "github_token" {
  count = var.github_token_ssm_param == "" ? 0 : 1

  name = var.github_token_ssm_param
}

resource "aws_codebuild_source_credential" "github_token" {
  count = var.github_token_ssm_param == "" ? 0 : 1

  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github_token[0].value
}

resource "aws_iam_role" "codebuild" {
  count = var.github_url == "" ? 0 : 1

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
  count = var.github_url == "" ? 0 : 1

  role = aws_iam_role.codebuild[0].name

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
  count = var.github_url == "" ? 0 : 1

  name          = var.layer_name
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild[0].arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode
  }

  source {
    type            = "GITHUB"
    location        = var.github_url
    git_clone_depth = 1

    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.github_token[0].token
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
      pattern = "master"
    }
  }
}
