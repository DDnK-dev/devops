#!/bin/bash

NA=argocd
HELM_NAME=argocd

helm delete ${HELM_NAME} -n {NS}
kubectl delete -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n ${NS}
