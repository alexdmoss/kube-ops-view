#!/usr/bin/env bash
set -euo pipefail

function deploy() {

  _assert_variables_set USERNAME PASSWORD HOSTNAME

  pushd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null

  # when running in CI, we need to set up gcloud/kubeconfig
  if [[ ${DRONE:-} == "true" ]]; then
    _assert_variables_set K8S_DEPLOYER_CREDS K8S_CLUSTER_NAME GCP_PROJECT_ID
    _console_msg "-> Authenticating with GCloud"
    echo "${K8S_DEPLOYER_CREDS}" | gcloud auth activate-service-account --key-file -
    region=$(gcloud container clusters list --project="${GCP_PROJECT_ID}" --filter "NAME=${K8S_CLUSTER_NAME}" --format "value(zone)")
    _console_msg "-> Authenticating to cluster ${K8S_CLUSTER_NAME} in project ${GCP_PROJECT_ID} in ${region}"
    gcloud container clusters get-credentials "${K8S_CLUSTER_NAME}" --project="${GCP_PROJECT_ID}" --region="${region}"
  fi

  popd >/dev/null

  pushd "k8s/" >/dev/null

  _console_msg "Creating username/password"
  htpasswd -bc ./auth "${USERNAME}" "${PASSWORD}"

  _console_msg "Applying Kubernetes yaml"
  kustomize build . | envsubst | kubectl apply -f -
  kubectl rollout status deploy/kube-ops-view -n=ops-view
  
  popd >/dev/null

}

function _assert_variables_set() {
  local error=0
  local varname
  for varname in "$@"; do
    if [[ -z "${!varname-}" ]]; then
      echo "${varname} must be set" >&2
      error=1
    fi
  done
  if [[ ${error} = 1 ]]; then
    exit 1
  fi
}

function _console_msg() {
  local msg=${1}
  local level=${2:-}
  local ts=${3:-}
  if [[ -z ${level} ]]; then level=INFO; fi
  if [[ -n ${ts} ]]; then ts=" [$(date +"%Y-%m-%d %H:%M")]"; fi
  echo
  if [[ ${level} == "ERROR" ]] || [[ ${level} == "CRIT" ]] || [[ ${level} == "FATAL" ]]; then
    (echo 2>&1)
    (echo >&2 "-> [${level}]${ts} ${msg}")
  else 
    (echo "-> [${level}]${ts} ${msg}")
  fi
  echo
}

deploy