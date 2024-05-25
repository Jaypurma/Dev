variable "vpc" {
  default = {
    id   = "vpc-0eed3a9b763bb9106"
    cidr = "0.0.0.0/0"
  }
}
variable "region" {
  default = "ap-south-1"
}

variable "image" {
  default = "ami-0f58b397bc5c1f2e8"
}

variable "size" {
  default = "t2.micro"
}

variable "tag" {
  default = "apache"
}

variable "type" {
  default = "t2.micro"
}
# SSH_USER
variable "login_user" {
  default = "ubuntu"
}
