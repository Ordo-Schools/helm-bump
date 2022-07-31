#!/bin/ash

set -e

echo "RUNNING HELM RUNNER ENTRYPOINT!"

if [ ! -z "$BASE64_KUBECONFIG" ]; then
  echo "KUBECONFIG ENV VAR FOUND!"
  mkdir -p /.kube
  echo "$BASE64_KUBECONFIG" | base64 -d > /.kube/config
  chmod 600 /.kube/config
  export KUBECONFIG=
  echo "SET KUBECONFIG FILE TO /.kube/config"
fi

# Run command with helm if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- helm "$@"
fi

exec "$@"