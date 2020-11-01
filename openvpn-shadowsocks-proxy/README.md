# vpn-proxy-aws

## Overview

Setup ec2 instance with openvpn+shadowsocks server & squid http proxy

## Usage

```sh
terraform init
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 0.13 |
| aws       | >= 3.10 |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | >= 3.10 |

## Inputs

| Name                | Description                                       | Type          | Default                                                    | Required |
| ------------------- | ------------------------------------------------- | ------------- | ---------------------------------------------------------- | :------: |
| amis                | aws amazon machine images                         | `map(string)` | <pre>{<br> "us-east-2": "ami-01237fce26136c8cc"<br>}</pre> |    no    |
| disable_termination | disable instance termination                      | `bool`        | `false`                                                    |    no    |
| instance_type       | instance type                                     | `string`      | `"t2.micro"`                                               |    no    |
| name                | project name, resources prefix, instance tag Name | `string`      | n/a                                                        |   yes    |
| openvpn_client_name | openvpn profile                                   | `string`      | `"profile"`                                                |    no    |
| profile             | aws profile                                       | `string`      | `"default"`                                                |    no    |
| region              | aws instance region                               | `string`      | `"us-east-2"`                                              |    no    |
| squid_password      | squid password                                    | `string`      | n/a                                                        |   yes    |
| squid_port          | squid port                                        | `number`      | `3128`                                                     |    no    |
| squid_user          | squid user                                        | `string`      | n/a                                                        |   yes    |
| ss_client_port      | shadowsocks client port                           | `number`      | `1080`                                                     |    no    |
| ss_password         | shadowsocks password                              | `string`      | n/a                                                        |   yes    |
| ss_port             | shadowsocks server port                           | `number`      | `443`                                                      |    no    |

## Outputs

| Name            | Description           |
| --------------- | --------------------- |
| closing_message | closing message       |
| proxy_usage     | proxy usage           |
| ssh_to_server   | ssh connection string |
| vpn_usage       | vpn usage             |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
