variable "name" {
  type = string
}

variable "profile" {
  default = "default"
}

variable "region" {
  default = "us-east-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "amis" {
  type = map(string)
  default = {
    us-east-2 = "ami-01237fce26136c8cc"
  }
}

variable "server_port" {
  type = number
}

variable "instance_count" {
  default = 1
}
