variable "name" {
  type        = string
  description = "project name, resources prefix, instance tag Name"
}

variable "region" {
  type        = string
  default     = "us-east-2"
  description = "aws instance region"
}

variable "profile" {
  type        = string
  default     = "default"
  description = "aws profile"
}

variable "instance_type" {
  type        = string
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

## Hello World

variable "hello_world_port" {
  type        = number
  default     = 1234
  description = "hello world port"
}

variable "hello_world_from" {
  type        = string
  default     = "any place"
  description = "hello world from message"
}

# variable "public_key" {
#   type = string
# }

# variable "aws_access_key" {
#   type = string
# }

# variable "aws_secret_key" {
#   type = string
# }
