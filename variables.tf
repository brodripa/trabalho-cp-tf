variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "projeto_vpc_cidr" {
  description = "CIDR block para a VPC do projeto"
  type        = string
  default     = "10.0.0.0/16"
}
