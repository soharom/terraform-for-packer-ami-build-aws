variable "remote_repository" {
  type = string
  default = "https://github.com/soharom/packer-ami-aws-template.git"
}

variable "repository_name" {
  type = string
  default = "packer-ami-aws-template"
}

variable "codecommit_user" {
    type = string
    default = "codecommit_user"
  
}
variable "profile" {
    type = string
    default = "default"
  
}
variable "region" {
    type = string
    default = "us-east-1"
}

variable "access_key" {
    type = string
  
}

variable "secret_key" {
    type = string
}

variable "image" {
  type = string
  default = "aws/codebuild/standard:7.0"
  
}

variable "type" {
  type = string
  default = "BUILD_GENERAL1_SMALL"
  
}


variable "branch" {
  type = string
  default = "master"
  
}