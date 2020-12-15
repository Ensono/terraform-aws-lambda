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

variable "github_url" {
  type    = string
  default = ""
}

variable "codebuild_image" {
  type    = string
  default = "aws/codebuild/standard:4.0"
}

variable "privileged_mode" {
  type    = string
  default = false
}

variable "codebuild_credential_arn" {
  type    = string
  default = ""
}

variable "build_timeout" {
  type    = string
  default = "60"
}

variable "git_branch" {
  type    = string
  default = "master"
}