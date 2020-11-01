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

variable "disable_termination" {
  type        = bool
  description = "disable instance termination"
  default     = false
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

# SQUID

variable "squid_port" {
  type        = number
  default     = 3128
  description = "squid port"
}

variable "squid_user" {
  type        = string
  description = "squid user"
}

variable "squid_password" {
  type        = string
  description = "squid password"
}

# OPENVPN

variable "openvpn_client_name" {
  type        = string
  default     = "profile"
  description = "openvpn profile"
}

# SHADOWSOCKS (SS) SERVER

variable "ss_client_port" {
  type        = number
  default     = 1080
  description = "shadowsocks client port"
}

variable "ss_port" {
  type        = number
  default     = 443
  description = "shadowsocks server port"
}

variable "ss_password" {
  type        = string
  description = "shadowsocks password"
}
