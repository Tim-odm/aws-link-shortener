variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets for the cluster and worker nodes"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for the worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Number of worker nodes to run normally"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Fewest worker nodes allowed"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Most worker nodes allowed"
  type        = number
  default     = 3
}
