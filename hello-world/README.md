# hello-world

## Overview

Terraform hello world example

## Usage

```sh
terraform init
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.10 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.10 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| amis | aws amazon machine images | `map(string)` | <pre>{<br>  "us-east-2": "ami-01237fce26136c8cc"<br>}</pre> | no |
| hello\_world\_from | hello world from message | `string` | `"any place"` | no |
| hello\_world\_port | hello world port | `number` | `1234` | no |
| instance\_type | instance type | `string` | `"t2.micro"` | no |
| name | project name, resources prefix, instance tag Name | `string` | n/a | yes |
| profile | aws profile | `string` | `"default"` | no |
| region | aws instance region | `string` | `"us-east-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| closing\_message | closing message |
| ssh\_connection | ssh connection string |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
