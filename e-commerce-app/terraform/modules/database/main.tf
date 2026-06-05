resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.environment}-rds-subnet-group"
  subnet_ids  = var.data_subnet_ids
  description = "Database subnet group for transactional RDS instances"
}

resource "aws_db_instance" "sql_db" {
  identifier            = "${var.environment}-sql-database"
  engine                = "postgres"
  engine_version        = "15.4"
  instance_class        = var.rds_instance_class
  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.db_security_group_id]

  multi_az            = var.environment == "prod" ? true : false
  skip_final_snapshot = var.environment == "prod" ? false : true
  storage_encrypted   = true

  tags = {
    Name = "${var.environment}-rds-postgres"
  }
}

resource "aws_dynamodb_table" "nosql_table" {
  name         = "${var.environment}-application-data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "${var.environment}-dynamodb"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.data_subnet_ids
}

resource "aws_elasticache_replication_group" "redis_cache" {
  description          = "Redis cluster for web tier caching and session state"
  replication_group_id = "${var.environment}-redis-cluster"
  node_type            = var.redis_node_type
  num_cache_clusters   = var.environment == "prod" ? 2 : 1
  port                 = 6379

  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [var.cache_security_group_id]

  automatic_failover_enabled = var.environment == "prod" ? true : false
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = var.redis_auth_token

  tags = {
    Name = "${var.environment}-redis"
  }
}
