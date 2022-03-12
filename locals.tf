# Localised usage of merge() will override values set here if "${local.default_tags}" appears first.
locals {
  default_tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Owner       = "${var.owner}"
    ManagedBy   = "Terraform"
  }
}
