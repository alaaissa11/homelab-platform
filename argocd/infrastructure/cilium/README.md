# Cilium

Cilium est installé manuellement via Helm, et non géré par ArgoCD.

## Raison

Cilium est le CNI du cluster. Il est indispensable pour que les pods communiquent.

Or, ArgoCD a besoin du réseau pour fonctionner. C'est un problème d'oeuf et de poule.

## Solution

Cilium est installé manuellement AVANT ArgoCD :

    helm repo add cilium https://helm.cilium.io/
    helm install cilium cilium/cilium --namespace kube-system

## Vérification

    kubectl get pods -n kube-system | grep cilium
    kubectl get nodes
