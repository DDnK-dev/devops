# ARGOCD 초기화 기록장

ref: https://velog.io/@brillog/ArgoCD-%EA%B8%B0%EB%B3%B8-%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0-Cluster-Account-%EC%83%9D%EC%84%B1


argocd login localhost:30998 --username admin --password argo2024!!
argocd cluster add docker-desktop -y

$ kubectl edit configmap argocd-cm -n argocd
apiVersion: v1
data:
  accounts.<NEW_ACCOUNT_NAME>: apiKey,login
  accounts.<NEW_ACCOUNT_NAME>.enabled: "true"
kind: ConfigMap
metadata:
  annotations:
  ...

argocd account list
argocd account update-password --account ddnk
