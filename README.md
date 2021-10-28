# AWS RDS Terraform module

Terraform module which creates **RDS** resources on **AWS**. This module is an abstraction of the [MODULE_NAME](https://github.com/a_great_module) by [@someoneverysmart](https://github.com/someoneverysmart).

## User Stories for this module

- AAOps I can create a postgres database with its name, subnet, version, disk (type and size), max connections number, with HA or no
- AAOps I can choose if I access my Database with SSL
- AAOps Credentials are stored in secret Manager
- AAOps I can create a KMS key or use an existing one to encrypt secrets
## Usage

```hcl
module "rds" {
  source = "https://github.com/padok-team/terraform-aws-rds.git"

  # =============================[ General ]=============================
  tags = {
    "name" : "rds-poc-library-multi-az",
    "managedByTerraform" : true,
    "port" : 5432,
    "env" : "poc-library"
  }
  aws_region    = "eu-west-3"
  aws_region_az = ["a", "b", "c"]

  # =============================[ RDS Instance ]=============================
  storage_type                       = "gp2"
  vpc_security_group_ids             = ["ssg1"]
  identifier                         = "rds-poc-library-multi-az"
  instance_class                     = "db.t3.micro"
  allocated_storage                  = 10
  engine                             = "postgres"
  engine_version                     = "13.4"
  db_parameter_family                = "postgres13"
  multi_az                           = true
  performance_insights_enabled       = true
  name                               = "aws_rds_instance_poc_library_multi_az"
  username                           = "aws_rds_instance_user_poc_library_multi_az"
  backup_retention_period            = 10
  port                               = 5432
  apply_immediately                  = false
  max_allocated_storage              = 20
  subnet_ids                         = ["subnet1", "subnet2"]
  rds_secret_recovery_window_in_days = 10
  rds_skip_final_snapshot            = true
  force_ssl                          = true

  custom_kms_key        = false
  custom_kms_key_secret = false
}
```

## Examples

- [AAOps I deploy a postgres rds instance with multi AZ availability with custom KMS key for secrets and rds encryption](examples/multi_az_rds_instance_postgres/main.tf)
- [AAOps I Deploy a postgres rds instance without multi AZ and with auto generated KMS Keys](examples/one_az_rds_instance_postgres/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Storage allocated to your RDS instance | `number` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | n/a | yes |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Backup retention period | `number` | n/a | yes |
| <a name="input_db_parameter_family"></a> [db\_parameter\_family](#input\_db\_parameter\_family) | The family of the DB parameter group | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine used for your RDS instance (mysql, postgres ...) | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version of your engine | `string` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Unique identifier for your RDS instance | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance class for your RDS instance | `string` | n/a | yes |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance | `number` | n/a | yes |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Set to true to deploy a multi AZ RDS instance | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of your RDS instance | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Set to true to enable performance insights on your RDS instance | `bool` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections | `number` | n/a | yes |
| <a name="input_rds_secret_recovery_window_in_days"></a> [rds\_secret\_recovery\_window\_in\_days](#input\_rds\_secret\_recovery\_window\_in\_days) | Secret recovery window in days | `number` | n/a | yes |
| <a name="input_rds_skip_final_snapshot"></a> [rds\_skip\_final\_snapshot](#input\_rds\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted | `bool` | n/a | yes |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD) | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs to create your db subnet group | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to attach to all resources created by this module | `map(any)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Name of the master user for your RDS instance | `string` | n/a | yes |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate | `list(any)` | n/a | yes |
| <a name="input_arn_custom_kms_key"></a> [arn\_custom\_kms\_key](#input\_arn\_custom\_kms\_key) | Arn of your custom KMS Key. Useful only if custom\_kms\_key is set to true | `string` | `""` | no |
| <a name="input_arn_custom_kms_key_secret"></a> [arn\_custom\_kms\_key\_secret](#input\_arn\_custom\_kms\_key\_secret) | Encrypt AWS secret with CMK | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region that will be used for subnets deployments | `string` | `"eu-west-3"` | no |
| <a name="input_aws_region_az"></a> [aws\_region\_az](#input\_aws\_region\_az) | AZ letter list. The module will deploy one subnet per AZ | `list(any)` | <pre>[<br>  "a",<br>  "b"<br>]</pre> | no |
| <a name="input_custom_kms_key"></a> [custom\_kms\_key](#input\_custom\_kms\_key) | Set to true to use a custom KMS key. If set to true the module will create KMS Key | `bool` | `false` | no |
| <a name="input_custom_kms_key_secret"></a> [custom\_kms\_key\_secret](#input\_custom\_kms\_key\_secret) | Use a custom KMS key to encrypt secrets | `bool` | `false` | no |
| <a name="input_force_ssl"></a> [force\_ssl](#input\_force\_ssl) | Force SSL for DB connections | `string` | `false` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_password_length"></a> [password\_length](#input\_password\_length) | Password length for db | `number` | `128` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
