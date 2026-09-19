resource "null_resource" "k3d_cluster" {
  triggers = {
    cluster_name = var.cluster_name
    servers      = var.servers
    agents       = var.agents
    k3s_image    = var.k3s_image
  }

  provisioner "local-exec" {
    command = <<-EOT
      k3d cluster create ${var.cluster_name} \
        --servers ${var.servers} \
        --agents ${var.agents} \
        --image ${var.k3s_image} \
        --kubeconfig-update-default \
        --kubeconfig-switch-context
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "k3d cluster delete ${self.triggers.cluster_name}"
  }
}
