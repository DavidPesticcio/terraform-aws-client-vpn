# find cert
# data "aws_acm_certificate" "issued" {
# domain      = "*.pinkloop.com"
# domain      = "pinkloop.com"
# domain = "*"
# domain      = "*.pinkloop.com"
# domain      = "*.pinkloop.com"
# statuses    = ["ISSUED"]
# most_recent = true
# key_types   = ["EC_secp384r1"]
# key_types   = ["RSA_2048"]
# types       = ["IMPORTED"]

# depends_on = [
#     aws_acm_certificate.pinkloop_client1,
#     aws_acm_certificate.pinkloop_server1
# ]
# }

data "aws_region" "current" {

}

# AWS instance
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
