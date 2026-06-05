region         = "us-east-1"
cluster_name   = "production-ecommerce"
environment    = "prod"
aws_account_id = "123456789012"

domain_name         = "your-company-platform.com"
acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abcdef-1234-5678"

db_name     = "ecommercedb"
db_username = "db_admin_user"
db_password = "SuperSecurePassword123!" # If you're using it indie a CI/CD pipeline, make sure to use it as env variable

redis_auth_token = "you-token-ldjflqjdfkljflkdsxjflqsjfldlkdjfqljfl" # Smae here

worker_ami_id = "ami-0c7217cdde317cfec"

awsadmin             = "analytics_admin"
secret_redshift_pass = "RedshiftSecurePass789!"
sre_email            = "sre-alerts@my-company.com"

payment_processor_cidr = "127.0.0.1/24" # If you're using an external payment service
