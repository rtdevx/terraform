# INFO: RDS
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance

# INFO: Create DB Instance
resource "aws_db_instance" "rdsdb" {
  allocated_storage     = 5
  max_allocated_storage = 10
  db_name               = var.db_name
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  port                  = 3306
  //engine                      = data.aws_rds_orderable_db_instance.custom-sqlserver.engine
  //engine_version              = data.aws_rds_orderable_db_instance.custom-sqlserver.engine_version
  //instance_class              = data.aws_rds_orderable_db_instance.custom-sqlserver.instance_class
  username = var.db_username
  password = var.db_password
  //kms_key_id                  = data.aws_kms_key.by_id.arn
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  deletion_protection  = false

  auto_minor_version_upgrade = false
  backup_retention_period    = 0
  db_subnet_group_name       = module.vpc.database_subnet_group
  vpc_security_group_ids     = [aws_security_group.private-db-3306.id, aws_security_group.db-egress.id]
  identifier                 = var.db_instance_identifier
  multi_az                   = false
  storage_encrypted          = true

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  performance_insights_enabled = false
  //performance_insights_retention_period = 7 # NOTE: Only enable when `performance_insights_enabled` is set to true

  timeouts {
    create = "40m"
    delete = "90m"
    update = "1h"
  }

  tags = local.common_tags
}

# TODO: Use KMS_KEY instead of a variable
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#managed-master-passwords-via-secrets-manager-default-kms-key