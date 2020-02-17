variable "aws_region" {
  default     = "us-east-1"
  description = "The region of AWS"
}

variable "layer_name" {
  type = string
}

variable "description" {
  type = string
}

variable "runtime" {
  type = string
}

variable "filename" {
  type    = string
  default = ""
}

variable "create_empty_layer" {
  default = true
}

variable "reserved_concurrent_executions" {
  default = "-1"
}

variable "github_token_ssm_param" {
  type = string
}

variable "github_url" {
  type = string
}