variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable AWS_REGION {
  default = "us-west-2"
}

variable "az1" {
  description = "Availability Zone 1"
  default     = "us-west-2a"
}

variable "az2" {
  description = "Availability Zone 2"
  default     = "us-west-2b"
}

variable "ava_zones" {
  default = ["us-west-2a", "us-west-2b"]
}
