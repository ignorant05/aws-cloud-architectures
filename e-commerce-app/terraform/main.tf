terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  region     = var.region
  vpc_name   = var.cluster_name
}

module "routing" {
  source            = "./modules/routing"
  cluster_name      = var.cluster_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "security" {
  source                 = "./modules/security"
  vpc_id                 = module.vpc.vpc_id
  environment            = var.environment
  vpc_cidr_block         = module.vpc.vpc_cidr_block
  payment_processor_cidr = var.payment_processor_cidr
}

module "edge" {
  source              = "./modules/edge"
  environment         = var.environment
  project_name        = var.cluster_name
  primary_domain_name = var.domain_name
  domain_aliases      = ["www.${var.domain_name}", "api.${var.domain_name}"]
  acm_certificate_arn = var.acm_certificate_arn

  api_gateway_domain_name = module.integration.api_gateway_domain_name
}

module "database" {
  source          = "./modules/database"
  environment     = var.environment
  data_subnet_ids = module.vpc.data_subnet_ids

  db_security_group_id    = module.security.rds_sg_id
  cache_security_group_id = module.security.redis_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  redis_auth_token = var.redis_auth_token
}

module "compute" {
  source      = "./modules/compute"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  aws_region  = var.region

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  pci_subnet_ids     = module.vpc.PCI_isolated_subnet_ids

  public_alb_sg_id = module.security.public_alb_sg_id
  ecs_tasks_sg_id  = module.security.ecs_tasks_sg_id
  worker_sg_id     = module.security.worker_sg_id

  ecs_exec_role_arn = module.security.ecs_exec_role_arn
  ecs_task_role_arn = module.security.ecs_task_role_arn

  cloudwatch_log_group_name = module.observability.cloudwatch_log_group_name

  container_registry_url = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
  ami_id                 = var.worker_ami_id
}

module "integration" {
  source      = "./modules/integration"
  environment = var.environment

  step_functions_role_arn   = module.security.step_functions_role_arn
  lambda_execution_role_arn = module.security.lambda_role_arn

  public_alb_listener_arn = module.compute.public_alb_arn

  sre_email = var.sre_email
}

module "analytics_search" {
  source               = "./modules/analytics_search"
  environment          = var.environment
  project_name         = var.cluster_name
  data_subnet_ids      = module.vpc.data_subnet_ids
  analytics_subnet_ids = module.vpc.analytics_subnet_ids

  search_security_group_id    = module.security.search_sg_id
  analytics_security_group_id = module.security.analytics_sg_id
  firehose_iam_role_arn       = module.security.ecs_exec_role_arn
  glue_iam_role_arn           = module.security.lambda_role_arn

  redshift_admin_username = var.awsadmin
  redshift_admin_password = var.secret_redshift_pass
}

module "observability" {
  source            = "./modules/observability"
  environment       = var.environment
  sre_email_address = var.sre_email
  ecs_cluster_name  = module.compute.ecs_cluster_name
}
