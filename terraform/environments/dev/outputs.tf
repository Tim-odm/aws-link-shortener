output "cluster_role_arn" {
  value = module.eks.cluster_role_arn
}

output "node_role_arn" {
  value = module.eks.node_role_arn
}
