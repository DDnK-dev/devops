#!/bin/bash



NS=argocd
HELM_NAME=argocd
ArgoServer=argocd-server

# install argocd package and cli
function install_argocd() {
  # install argocd
  helm install ${HELM_NAME} -n ${NS} --create-namespace -f values.yaml ./argo-cd

  # install argocd cli
  brew install argocd
}

# install argocd, if already exists skip process
function install_argocd_with_check() {
  # 1 is true, else value is false
  isNamespaceExist=$(kubectl get ns ${NS} --no-headers | wc -l)
  if [ "$isNamespaceExist" -eq "1" ]; then
    echo "argocd namespacea already exists"
    return 2
  fi

  isArgoServerDeployed=$(kubectl get deploy -n argocd ${ArgoServer} --no-headers | awk {'print $2'})
  if [ "$isArgoServerDeployed" == "1/1" ]; then
    echo "argo server is not deployed or ready"
    return 2
  fi

  install_argocd
  return 1
}

# patch argocd svc type to LoadBalancer
function patch_api_server() {
  kubectl patch svc argocd-server -n ${NS} -p '{"spec": {"type": "LoadBalancer"}}'
}

# get init password from argocd secret
function get_init_password() {
  isSecretExists=$(kubectl get secret -n ${NS} argocd-initial-admin-secret --no-headers | wc -l | awk {'print $1'})
  if [ "$isSecretExists" != "1" ]; then
    echo "password seems to alreay modified"
    return 2
  fi

  INIT_PASSWD=$(kubectl get secret -n ${NS} argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 --decode)
  echo $INIT_PASSWD
}


# exec all processes
function main() {
  install_argocd_with_check
  res=$?
  if [ "$res" != "1" ]; then
    echo "argocd seems to be already installed, skip install"
  fi
  patch_api_server
  passwd=$(get_init_password)
  external_ip=$(kubectl get svc -n argocd argocd-server --no-headers | awk {'print $4'})

  echo ""
  echo ""
  echo "========Install Complete========"
  echo "admin id : admin"
  echo "password : $passwd"
  echo "you can login via http://$external_ip"
  echo "================================"
}

main
