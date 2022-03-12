# Create VPC
resource "aws_vpc" "vpn" {
  cidr_block = var.vpc_cidr_block

  instance_tenancy = "default"

  tags = merge(
    {
      Name = "vpn"
    },
    local.default_tags
  )
}

resource "aws_flow_log" "vpn" {
  vpc_id               = aws_vpc.vpn.id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.vpc_flow_logs.arn
  # other required fields here

  tags = merge(
    {
      Name = "vpn"
    },
    local.default_tags
  )
}


# Subnet for VPN Clients
resource "aws_subnet" "vpn" {
  vpc_id     = aws_vpc.vpn.id
  cidr_block = cidrsubnet(aws_vpc.vpn.cidr_block, 6, 1)

  tags = merge(
    {
      Name = "vpn"
    },
    local.default_tags
  )
}

# Subnet to associate to VPN Clients
resource "aws_subnet" "jump_server" {
  vpc_id     = aws_vpc.vpn.id
  cidr_block = cidrsubnet(aws_vpc.vpn.cidr_block, 6, 2)

  tags = merge(
    {
      Name = "jump_server"
    },
    local.default_tags
  )
}
