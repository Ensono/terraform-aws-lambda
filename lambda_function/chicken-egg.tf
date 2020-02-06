data "archive_file" "lambda_placeholder" {
  count       = var.create_empty_function ? 1 : 0
  type        = "zip"
  output_path = "${path.module}/placeholder.zip"

  source_dir = "${path.module}/placeholders/${var.runtime}"
}

locals {
  source = {
    "python2.7"  = "${path.module}/placeholders/python2.7"
    "python3.7"  = "${path.module}/placeholders/python3.7/"
    "python3.6"  = "${path.module}/placeholders/python3.6/"
    "nodejs6.10" = "${path.module}/placeholders/nodejs6.10/"
    "nodejs8.10" = "${path.module}/placeholders/nodejs8.10/"
    java8        = "${path.module}/placeholders/java8"
  }
}
