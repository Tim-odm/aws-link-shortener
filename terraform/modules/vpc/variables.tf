variable "cluster_name" {
  description = "Name of the EKS cluster, used for naming and tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "IP address range for the whole VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "IP ranges for the public subnets, one per AZ"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "IP ranges for the private subnets, one per AZ"
  type        = list(string)
}

