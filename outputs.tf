output "tls_cert_ca" {
  description = "Root CA certificate"
  value       = tls_self_signed_cert.ca.cert_pem
}

output "tls_cert_vpn" {
  description = "VPN certificate"
  value       = tls_locally_signed_cert.vpn.cert_pem
}

output "tls_cert_client1" {
  description = "Client 1 certificate"
  value       = tls_locally_signed_cert.client1.cert_pem
}

output "aws_region_full" {
  description = "Current deployment region description and region name."
  value       = "${data.aws_region.current.description} (${data.aws_region.current.name})"
}
