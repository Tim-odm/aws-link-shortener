# AWS Link Shortener

Project introduction
- Motivation
- Key design decisions
- Results

## Terraform Configs

Different terraform modules can be found in `terraform/modules`.

### EKS

The `terraform/modules/eks/` module is responsible for creating IAM roles for 
the cluster and node (EC2) instances. 

### VPC

The `terraform/modules/vpc/` module is responsible for configuring the private 
network that EKS depends on. It consists of;
- Two public subnets
- Two private subnets
- An internet gateway
- A NAT gateway
- Route tables
