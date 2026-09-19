variable "cluster_name" {
  description = "Nom du cluster k3d"
  type        = string
  default     = "homelab"
}

variable "servers" {
  description = "Nombre de nœuds master"
  type        = number
  default     = 1
}

variable "agents" {
  description = "Nombre de nœuds workers"
  type        = number
  default     = 2
}

variable "k3s_image" {
  description = "Image k3s à utiliser"
  type        = string
  default     = "rancher/k3s:v1.31.5-k3s1"
}
