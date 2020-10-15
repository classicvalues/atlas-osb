#!/bin/bash
source ".github/base-dockerfile/helpers/params.sh"
set -e

helm version
aws --version
aws eks --region us-east-2 update-kubeconfig --name atlas-osb-eks
kubectl version

helm uninstall "${K_TEST_APP}" \
    --namespace "${K_NAMESPACE}"

helm uninstall "${K_SERVICE}" \
    --namespace "${K_NAMESPACE}"

# helm uninstall "${K_BROKER}" \
#     --namespace "${K_NAMESPACE}"

kubectl get all -n "${K_NAMESPACE}"
# kubectl delete namespace "${K_NAMESPACE}"