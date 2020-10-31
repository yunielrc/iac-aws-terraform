locals {
  user        = "ubuntu"
  cidr_blocks = ["0.0.0.0/0"]
  sufix       = formatdate("YYYYMMDDhhmmss", timestamp())
  p_data      = "./provision/data"
  p_scripts   = "./provision/scripts"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.name}-key-pair-${local.sufix}"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ubuntu_server_security_group" {
  name = "${var.name}-security-group-${local.sufix}"

  ingress {
    description = "tcp"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "icmp"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = local.cidr_blocks
  }

  egress {
    description = "outgoing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.cidr_blocks
  }
}

resource "aws_instance" "ubuntu_server" {
  count                  = var.instance_count
  ami                    = var.amis[var.region] # us-east-2 ubuntu 20.04 x64
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ubuntu_server_security_group.id]
  key_name               = aws_key_pair.key_pair.id

  tags = {
    Name = var.name
  }

  connection {
    type = "ssh"
    host = self.public_dns
    user = local.user
    # agent = true
  }

  # setup docker
  # provisioner "remote-exec" {
  #   inline = ["wget -qO - https://git.io/JJaKZ?=docker-ubuntu | bash"]
  # }

  # # UPLOAD DATA
  # provisioner "file" {
  #   source      = local.p_data
  #   destination = "/home/${local.user}"
  # }

  # # UPLOAD SCRIPTS
  # provisioner "file" {
  #   source      = local.p_scripts
  #   destination = "/tmp/scripts"
  # }

  # # PROVISION
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/scripts/provision",
  #     "/tmp/scripts/provision"
  #   ]
  # }
}
