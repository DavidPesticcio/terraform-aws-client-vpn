variable "project" {
  description = "The project name."
  type        = string
}

variable "environment" {
  description = "The project environment."
  type        = string
}

variable "owner" {
  description = "The project owner."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR Block."
  type        = string
}

variable "create_jump_server" {
  description = "Whether to create the Jump Server."
  type        = bool
  default     = false
}
