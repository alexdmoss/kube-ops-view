#!/usr/bin/env bash
set -euo pipefail

function deploy() {

  _assert_variables_set USERNAME PASSWORD HOSTNAME

  pushd "$(dirname "${BASH_SOURCE[0]}")/k8s" >/dev/null

  _console_msg "Creating username/password"
  htpasswd -bc ./auth "${USERNAME}" "${PASSWORD}"

  _console_msg "Applying Kubernetes yaml"
  kubectl apply -f namespace.yaml
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