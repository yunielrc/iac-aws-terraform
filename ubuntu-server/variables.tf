variable "name" {
  type        = string
  description = "project name, resources prefix, instance tag Name"
}

variable "region" {
  default     = "us-east-2"
  description = "aws instance region"
}

variable "profile" {
  default     = "default"
  description = "aws profile"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "instance type"
}

variable "amis" {
  type = map(string)
  default = {
    us-east-2 = "ami-01237fce26136c8cc"
  }
  description = "aws amazon machine images"
}

variable "server_port" {
  type        = number
  description = "server port"
}

variable "instance_count" {
  default     = 1
  description = "instance count"
}
