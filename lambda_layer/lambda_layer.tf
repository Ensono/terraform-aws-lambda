resource "aws_lambda_layer_version" "layer" {
  layer_name          = var.layer_name
  description         = var.description
  filename            = var.create_empty_layer ? "${path.module}/placeholder.zip" : var.filename
  compatible_runtimes = [var.runtime]

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }
}