remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    region         = "${local.aws_region}"
    bucket         = "terraform-${local.bucket_name_clean}"
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = "${local.bucket_name_clean}-lock-table"
  }
}

locals {
  aws_region         = "eu-west-2"
  bucket_name        = "${local.aws_region}-${local.project}-${local.environment}-${local.owner}"
  bucket_name_clean  = "${lower(replace(local.bucket_name, " ", "-"))}"
  project            = "AWS Client VPN"                     # Set Per Project
  environment        = "dev"                                # Set Per Environment
  owner              = "${get_aws_caller_identity_user_id()}"   # Set Per CI/CD Role
  vpc_cidr_block     = "10.0.0.0/16"
  create_jump_server = false
}

inputs = {
  aws_region         = "${local.aws_region}"
  project            = "${local.project}"
  environment        = "${local.environment}"
  owner              = "${local.owner}"
  vpc_cidr_block     = "${local.vpc_cidr_block}"
  create_jump_server = "${local.create_jump_server}"
}
