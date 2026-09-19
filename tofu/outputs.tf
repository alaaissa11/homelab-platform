output "cluster_name" {
  description = "Nom du cluster k3d"
  value       = var.cluster_name
}

output "cluster_context" {
  description = "Contexte kubectl"
  value       = "k3d-${var.cluster_name}"
}

output "k3s_image" {
  description = "Image k3s utilisée"
  value       = var.k3s_image
}
