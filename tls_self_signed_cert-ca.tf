resource "tls_private_key" "ca" {
  algorithm   = "RSA"
  rsa_bits    = 2048
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "ca" {
  key_algorithm   = tls_private_key.ca.algorithm
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Root CA"
    organization        = "Organisation"
    organizational_unit = "Development"
    country             = "GB"
    locality            = "AWS Client VPN"
    province            = data.aws_region.current.description
  }
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = tls_private_key.ca.algorithm
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Root CA"
    organization        = "Organisation"
    organizational_unit = "Development"
    country             = "GB"
    locality            = "AWS Client VPN"
    province            = data.aws_region.current.description
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "digital_signature"
  ]

  validity_period_hours = 750

  is_ca_certificate = true
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem

  tags = merge(
    {
      Name = "ca"
    },
    local.default_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "ca-key" {
  filename = "tls/keys/ca.key"
  content  = tls_private_key.ca.private_key_pem
}

resource "local_file" "ca-crt" {
  filename = "tls/certs/ca.crt"
  content  = tls_self_signed_cert.ca.cert_pem
}
