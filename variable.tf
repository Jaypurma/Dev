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
variable "vpc" {
  default = {
    cidr        = "172.32.0.0/16"
    subnet_cidr = "172.32.0.0/24"
    my_ip       = "146.196.36.2/32"
    vpc_name    = "practice_vpc"
    subnet_name = "practice-subnet"
  }
}