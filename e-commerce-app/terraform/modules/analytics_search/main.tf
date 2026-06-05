resource "aws_kinesis_stream" "data_ingestion" {
  name             = "${var.environment}-data-ingestion-stream"
  shard_count      = var.kinesis_shard_count
  retention_period = 24

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_s3_bucket" "analytics_storage" {
  bucket        = "${var.environment}-${var.project_name}-analytics-data"
  force_destroy = true
}

resource "aws_kinesis_firehose_delivery_stream" "data_dumping" {
  name        = "${var.environment}-data-dumping-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.firehose_iam_role_arn
    bucket_arn = aws_s3_bucket.analytics_storage.arn

    processing_configuration {
      enabled = false
    }
  }
}

resource "aws_opensearch_domain" "search_engine" {
  domain_name    = "${var.environment}-search-engine"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type          = var.opensearch_instance_type
    instance_count         = var.environment == "prod" ? 2 : 1
    zone_awareness_enabled = var.environment == "prod" ? true : false
  }

  vpc_options {
    subnet_ids         = [var.data_subnet_ids[0]]
    security_group_ids = [var.search_security_group_id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp3"
  }

  encrypt_at_rest {
    enabled = true
  }
}

resource "aws_glue_catalog_database" "analytics_db" {
  name = "${var.environment}_catalog_database"
}

resource "aws_glue_crawler" "etl_crawler" {
  database_name = aws_glue_catalog_database.analytics_db.name
  name          = "${var.environment}-s3-etl-crawler"
  role          = var.glue_iam_role_arn

  s3_target {
    path = "s3://${aws_s3_bucket.analytics_storage.bucket}/"
  }
}

resource "aws_redshiftserverless_namespace" "warehouse_namespace" {
  namespace_name      = "${var.environment}-warehouse-namespace"
  db_name             = "analytics"
  admin_username      = var.redshift_admin_username
  admin_user_password = var.redshift_admin_password
}

resource "aws_redshiftserverless_workgroup" "warehouse" {
  workgroup_name = "${var.environment}-warehouse-workgroup"
  namespace_name = aws_redshiftserverless_namespace.warehouse_namespace.namespace_name
  base_capacity  = 8

  subnet_ids         = var.analytics_subnet_ids
  security_group_ids = [var.analytics_security_group_id]
}
