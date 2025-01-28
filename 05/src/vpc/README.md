## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.8.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.135.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.develop_a](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |
| [yandex_vpc_subnet.develop_b](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_cidr_a"></a> [vpc\_cidr\_a](#input\_vpc\_cidr\_a) | n/a | `list` | n/a | yes |
| <a name="input_vpc_cidr_b"></a> [vpc\_cidr\_b](#input\_vpc\_cidr\_b) | n/a | `list` | n/a | yes |
| <a name="input_vpc_name_a"></a> [vpc\_name\_a](#input\_vpc\_name\_a) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name_b"></a> [vpc\_name\_b](#input\_vpc\_name\_b) | n/a | `string` | n/a | yes |
| <a name="input_vpc_zone_a"></a> [vpc\_zone\_a](#input\_vpc\_zone\_a) | n/a | `string` | n/a | yes |
| <a name="input_vpc_zone_b"></a> [vpc\_zone\_b](#input\_vpc\_zone\_b) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_id_a"></a> [subnet\_id\_a](#output\_subnet\_id\_a) | n/a |
| <a name="output_subnet_id_b"></a> [subnet\_id\_b](#output\_subnet\_id\_b) | n/a |
| <a name="output_yandex_network_id"></a> [yandex\_network\_id](#output\_yandex\_network\_id) | n/a |
