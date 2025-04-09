#!/bin/bash

REPO=https://github.com/DDnK-dev/devops.git
NS=apm-instrumentation-operator-system
DIR_PATH=argocd/guestbook
ARGO_SERVER="--server=localhost --insecure"

argocd app create guestbook ${ARGO_SERVER} --repo ${REPO} --path ${DIR_PATH} --dest-namespace ${NS} --dest-server https://kubernetes.default.svc --directory-recurse

