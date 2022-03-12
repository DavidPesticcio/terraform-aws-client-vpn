resource "aws_instance" "jump_server" {
  count = var.create_jump_server ? 1 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = merge(
    {
      Name = "Jump Server"
    },
    local.default_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}
