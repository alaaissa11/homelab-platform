# Phase 3 : Composants d'infrastructure

## Objectif

Installer les composants essentiels qui transforment un cluster Kubernetes nu en plateforme complète.

## Composants installés

| Composant | Rôle | Namespace | Version |
|---|---|---|---|
| Cilium | Réseau (CNI) | kube-system | 1.16.5 |
| local-path-provisioner | Stockage | local-path-storage | inclus K3s |
| Cert-Manager | Certificats HTTPS | cert-manager | v1.16.2 |
| Sealed Secrets | Secrets chiffrés | kube-system | 2.16.1 |
| Prometheus + Grafana | Monitoring | monitoring | 67.4.0 |
| Loki | Logs | loki | 2.10.2 |

## Pattern utilisé

App of Apps : une Application racine (`root`) surveille `argocd/infrastructure/` et crée automatiquement les Applications filles.

## Structure

    argocd/infrastructure/
    ├── cilium/README.md
    ├── cert-manager/
    │   ├── app.yaml
    │   └── cluster-issuer.yaml
    ├── sealed-secrets/app.yaml
    ├── monitoring/app.yaml
    └── loki/app.yaml

## Problèmes rencontrés et solutions

### Longhorn abandonné

Longhorn nécessite open-iscsi, non disponible dans les conteneurs k3d.
Solution : utiliser local-path-provisioner (inclus dans K3s).

### DNS IPv6 cassé

CoreDNS retournait des adresses IPv6 NAT64 non routables.
Solution : bloquer les requêtes AAAA avec le plugin template.

### inotify trop bas

Promtail plantait à cause de la limite inotify trop basse.
Solution : augmenter fs.inotify.max_user_instances à 8192.

### Cilium après redémarrage

Cilium perd ses règles eBPF après un redémarrage de WSL2.
Solution : redémarrer le DaemonSet cilium.

## Commandes utiles

    # Vérifier tous les composants
    argocd app list
    kubectl get pods -A | grep -v "Running\|Completed"

    # Redémarrer Cilium (après redémarrage)
    kubectl -n kube-system rollout restart daemonset cilium

    # Redémarrer CoreDNS
    kubectl -n kube-system rollout restart deployment coredns

    # Accéder à Grafana
    kubectl port-forward --address 0.0.0.0 svc/monitoring-grafana -n monitoring 3001:80

    # Accéder à ArgoCD
    kubectl port-forward svc/argocd-server -n argocd 8081:443

## Rituel de redémarrage

Après un redémarrage de WSL2 :

    sudo sysctl fs.inotify.max_user_instances=8192
    kubectl -n kube-system rollout restart daemonset cilium
    kubectl -n argocd rollout restart deployment argocd-repo-server
    kubectl port-forward svc/argocd-server -n argocd 8081:443
    argocd login localhost:8081 --username admin --password TON_MOT_DE_PASSE --insecure
    argocd app list
