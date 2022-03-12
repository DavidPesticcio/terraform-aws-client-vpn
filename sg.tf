resource "aws_security_group" "vpn_access" {
  name   = "vpn_access"
  vpc_id = aws_vpc.vpn.id
  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    protocol    = "TCP"
    to_port     = 0
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(
    {
      Name = "vpn_access"
    },
    local.default_tags
  )
}

resource "aws_security_group" "vpn_dns" {
  name   = "vpn_dns"
  vpc_id = aws_vpc.vpn.id
  ingress {
    from_port       = 53
    protocol        = "UDP"
    to_port         = 53
    security_groups = [aws_security_group.vpn_access.id]
  }
  egress {
    from_port   = 53
    protocol    = "UDP"
    to_port     = 53
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = merge(
    {
      Name = "vpn_dns"
    },
    local.default_tags
  )
}

# Disable default SG ingress/egress for security reasons.
# Defaults commented below.
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpn.id

  # ingress {
  #   from_port = 0
  #   to_port   = 0
  #   protocol  = -1
  #   self      = true
  # }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = merge(
    {
      Name = "default"
    },
    local.default_tags
  )
}
