# renovate:datasource=endoflife-date depName=amazon-eks versioning=loose
cluster_version = "1.24"


resource "aws_elasticache_replication_group" "redis_replication_group" {
  replication_group_id       = var.replication_group_id
  description                = "shared-redis-replication-group"
  automatic_failover_enabled = true
  auto_minor_version_upgrade = true
  parameter_group_name       = aws_elasticache_parameter_group.redis_parameter_group.name
  node_type                  = "cache.t3.small"
  subnet_group_name          = aws_elasticache_subnet_group.db_subnet_group.name
  # renovate:datasource=endoflife-date depName=redis versioning=loose
  engine_version             = "6.x"
  multi_az_enabled           = true
  num_cache_clusters         = 2
  kms_key_id                 = aws_kms_key.encryption_key.arn
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = var.auth_token
  maintenance_window         = var.maintenance_window
  security_group_ids         = [aws_security_group.main.id]
  port                       = local.port

  lifecycle {
    ignore_changes = [security_group_names]
  }
}


module "rds" {
  # renovate:amiFilter=[{"Name":"engine","Values":["aurora-mysql"]}]
  engine_version = "8.0.mysql_aurora.3.06.0"
}
