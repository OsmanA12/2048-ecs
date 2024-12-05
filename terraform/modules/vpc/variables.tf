# VPC


variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "cs-vpc"
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group"
  default     = "2048-sg"
}



variable "internet_gateway_name" {
  type        = string
  description = "Name of the internet gateway"
  default     = "2048-igw"
}


variable "egress_internet_gateway_name" {
  type        = string
  description = "Name of the egress internet gateway"
  default     = "2048-egress-only-igw"
}

variable "availability_zone_a" {
  type        = string
  description = "Availability zone a"
  default     = "eu-west-2a"
}

variable "availability_zone_b" {
  type        = string
  description = "Availability zone b"
  default     = "eu-west-2b"
}