locals {
  user              = "ubuntu"
  cidr_blocks       = ["0.0.0.0/0"]
  sufix             = formatdate("YYYYMMDDhhmmss", timestamp())
  provision_home    = "./provision/home"
  provision_root    = "./provision/root"
  provision_scripts = "./provision/scripts"
}

provider "aws" {
  profile = var.profile
  region  = var.region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.name}-key-pair-${local.sufix}"
  public_key = file("~/.ssh/id_rsa.pub")
  # public_key = var.public_key
}

resource "aws_security_group" "security_group" {
  name = "${var.name}-security-group-${local.sufix}"

  ingress {
    description = "hello world"
    from_port   = var.hello_world_port
    to_port     = var.hello_world_port
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

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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

resource "aws_instance" "instance" {
  ami                    = var.amis[var.region] # us-east-2 ubuntu 20.04 x64
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  key_name               = aws_key_pair.key_pair.id

  tags = {
    Name = var.name
  }

  connection {
    type  = "ssh"
    host  = self.public_ip
    user  = local.user
    agent = true
  }

  # PROVISION

  ## enable ssh root login
  provisioner "remote-exec" {
    script = "${local.provision_scripts}/enable-ssh-root"
  }

  ## upload home data
  provisioner "file" {
    source      = "${local.provision_home}/"
    destination = "/home/${local.user}"
  }

  ## upload root data
  provisioner "file" {
    source      = "${local.provision_root}/"
    destination = "/"

    connection {
      type  = "ssh"
      host  = self.public_ip
      user  = "root"
      agent = true
    }
  }

  ## upload scripts
  provisioner "file" {
    source      = local.provision_scripts
    destination = "/tmp"
  }

  ## setup docker
  provisioner "remote-exec" {
    inline = ["wget -qO - https://git.io/JJaKZ?=docker-ubuntu | bash"]
  }

  # setup openvpn shadowsocks server
  provisioner "remote-exec" {
    inline = [
      <<-EOT
        chmod +x /tmp/scripts/setup-hello-world
        HELLO_WORLD_FROM="${var.hello_world_from}" \
        /tmp/scripts/setup-hello-world
      EOT
    ]
  }
}
