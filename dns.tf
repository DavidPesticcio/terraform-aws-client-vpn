resource "aws_route53_resolver_endpoint" "vpn_dns" {
  name      = "vpn-dns-access"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.vpn_dns.id]
  ip_address {
    subnet_id = aws_subnet.vpn.id
  }
  ip_address {
    subnet_id = aws_subnet.jump_server.id
  }

  tags = merge(
    {
      Name = "Self-Signed Client Certificate"
    },
    local.default_tags
  )
}
