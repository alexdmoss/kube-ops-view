#!/usr/bin/env bash

if [[ -z ${NAMESPACE} ]]; then echo "Must export NAMESPACE to deploy into"; exit 1; fi
if [[ -z ${APP_HOSTNAME} ]]; then echo "Must export APP_HOSTNAME for external access"; exit 1; fi

echo "Specify username for login:"
read username
htpasswd -c ./auth $username

kubectl delete secret basic-auth -n=${NAMESPACE}
kubectl create secret generic basic-auth -n=${NAMESPACE} --from-file=./auth
rm -f ./auth

cat ./k8s/*.yaml | envsubst | kubectl apply -n=${NAMESPACE} -f -
