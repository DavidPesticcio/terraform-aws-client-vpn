resource "tls_private_key" "vpn" {
  algorithm   = "RSA"
  rsa_bits    = 2048
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "vpn" {
  key_algorithm   = tls_private_key.vpn.algorithm
  private_key_pem = tls_private_key.vpn.private_key_pem

  subject {
    common_name         = "VPN Endpoint"
    organization        = "VPN Org"
    organizational_unit = "Development"
    country             = "GB"
    locality            = "AWS Client VPN"
    province            = data.aws_region.current.description
  }

  dns_names = [
    "vpn.pinkloop.com",       # The CNAME pointing to the VPN Endpoint DNS Name
    "vpn-endpoint.amazon.com" # The VPN Endpoint DNS Name
  ]

  ip_addresses = [
    "192.168.0.108", # The IP of the VPN Endpoint
  ]
}

resource "tls_locally_signed_cert" "vpn" {
  ca_key_algorithm   = tls_private_key.ca.algorithm
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem
  cert_request_pem   = tls_cert_request.vpn.cert_request_pem

  validity_period_hours = 750

  allowed_uses = [
    "client_auth",
    "server_auth",
    "digital_signature"
  ]
}

resource "aws_acm_certificate" "vpn" {
  private_key       = tls_private_key.vpn.private_key_pem
  certificate_body  = tls_locally_signed_cert.vpn.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem

  tags = merge(
    {
      Name = "vpn"
    },
    local.default_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "vpn-key" {
  filename = "tls/keys/vpn.key"
  content  = tls_private_key.vpn.private_key_pem
}

resource "local_file" "vpn-crt" {
  filename = "tls/certs/vpn.crt"
  content  = tls_locally_signed_cert.vpn.cert_pem
}
