# ubuntu-server

## Overview

ubuntu server instance

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
| instance\_count | instance count | `number` | `1` | no |
| instance\_type | instance type | `string` | `"t2.micro"` | no |
| name | project name, resources prefix, instance tag Name | `string` | n/a | yes |
| profile | aws profile | `string` | `"default"` | no |
| region | aws instance region | `string` | `"us-east-2"` | no |
| server\_port | server port | `number` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
