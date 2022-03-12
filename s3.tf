resource "aws_kms_key" "vpc_flow_logs" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 10

  tags = merge(
    {
      Name = "vpc_flow_logs"
    },
    local.default_tags
  )

}

resource "aws_s3_bucket" "vpc_flow_logs" {
  bucket        = aws_vpc.vpn.id
  force_destroy = true

  tags = merge(
    {
      Name = "vpc_flow_logs"
    },
    local.default_tags
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow_logs" {
  bucket = aws_s3_bucket.vpc_flow_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.vpc_flow_logs.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_account_public_access_block" "vpc_flow_logs" {
  block_public_acls   = true
  block_public_policy = true
}
