<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.analytics_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_crawler.etl_crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |
| [aws_kinesis_firehose_delivery_stream.data_dumping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_kinesis_stream.data_ingestion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [aws_opensearch_domain.search_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_redshiftserverless_namespace.warehouse_namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_namespace) | resource |
| [aws_redshiftserverless_workgroup.warehouse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshiftserverless_workgroup) | resource |
| [aws_s3_bucket.analytics_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_analytics_security_group_id"></a> [analytics\_security\_group\_id](#input\_analytics\_security\_group\_id) | n/a | `string` | n/a | yes |
| <a name="input_analytics_subnet_ids"></a> [analytics\_subnet\_ids](#input\_analytics\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_data_subnet_ids"></a> [data\_subnet\_ids](#input\_data\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_firehose_iam_role_arn"></a> [firehose\_iam\_role\_arn](#input\_firehose\_iam\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_glue_iam_role_arn"></a> [glue\_iam\_role\_arn](#input\_glue\_iam\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_kinesis_shard_count"></a> [kinesis\_shard\_count](#input\_kinesis\_shard\_count) | n/a | `number` | `1` | no |
| <a name="input_opensearch_instance_type"></a> [opensearch\_instance\_type](#input\_opensearch\_instance\_type) | n/a | `string` | `"t3.small.search"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | n/a | yes |
| <a name="input_redshift_admin_password"></a> [redshift\_admin\_password](#input\_redshift\_admin\_password) | n/a | `string` | n/a | yes |
| <a name="input_redshift_admin_username"></a> [redshift\_admin\_username](#input\_redshift\_admin\_username) | n/a | `string` | n/a | yes |
| <a name="input_search_security_group_id"></a> [search\_security\_group\_id](#input\_search\_security\_group\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->