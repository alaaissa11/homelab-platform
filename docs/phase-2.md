# Phase 2 : Bootstrap ArgoCD

## Objectif

Installer ArgoCD dans le cluster, le connecter au dépôt Git, et mettre en place le pattern "App of Apps".

## Architecture

- ArgoCD : outil GitOps qui synchronise Git avec le cluster.
- Namespace : `argocd`.
- Pattern : "App of Apps" avec une Application racine.

## Installation

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
