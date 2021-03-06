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
    description = "ss server tcp"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "ss server tcp"
    from_port   = var.ss_port
    to_port     = var.ss_port
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "http proxy"
    from_port   = var.squid_port
    to_port     = var.squid_port
    protocol    = "tcp"
    cidr_blocks = local.cidr_blocks
  }

  ingress {
    description = "icmp"
    from_port   = -1
    to_port     = -1
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
  disable_api_termination = var.disable_termination
  ami                     = var.amis[var.region] # us-east-2 ubuntu 20.04 x64
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.security_group.id]
  key_name                = aws_key_pair.key_pair.id

  tags = {
    Name = var.name
  }

  connection {
    type    = "ssh"
    host    = self.public_ip
    user    = local.user
    timeout = "1m"
    agent   = true
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

  # setup squid, openvpn-ssserver (shadowsocks-rust server)
  provisioner "remote-exec" {
    inline = [
      <<-EOT
        wget -qO - https://git.io/JT9Gz?=openvpn-shadowsocks-server-linux |
          WORKING_DIR=/home/${local.user}/openvpn-ssserver \
          SS_CLIENT_PORT=${var.ss_client_port} \
          SS_PORT=${var.ss_port} \
          SS_PASSWORD=${var.ss_password} \
          SS_HOST=ssserver-us \
          OPENVPN_CLIENT_NAME=${var.openvpn_client_name} \
          OPENVPN_HOST=openvpn-us \
          bash
      EOT
      ,
      <<-EOT
        chmod +x /tmp/scripts/setup-squid
        SQUID_PORT=${var.squid_port} \
        SQUID_USER=${var.squid_user} \
        SQUID_PASSWORD=${var.squid_password} \
        /tmp/scripts/setup-squid
      EOT
      ,
    ]
  }

  # add server public keys to local known hosts
  # copy vpn profile from server to local
  provisioner "local-exec" {
    command = <<-EOT
      ssh-keyscan -T 120 ${self.public_ip} >> ~/.ssh/known_hosts
      scp ${local.user}@${self.public_ip}:~/openvpn-ssserver/${var.openvpn_client_name}.ovpn ~/
    EOT
  }
}
