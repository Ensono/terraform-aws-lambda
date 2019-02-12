provider "aws" {
  region  = "${var.aws_region}"
  profile = "default"
}

variable "aws_region" {
  default = "eu-west-1"
}
