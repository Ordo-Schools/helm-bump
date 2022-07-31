#!/bin/ash

set -e

if [ ! -z "$BASE64_KUBECONFIG" ]; then
  echo "Decoding base64 kubeconfig into /.kube/config"
  mkdir -p /.kube
  echo "$BASE64_KUBECONFIG" | base64 -d > /.kube/config
  chmod 600 /.kube/config
  echo "Setting KUBECONFIG environment variable to /.kube/config"
  export KUBECONFIG=/.kube/config
fi

# Run command with helm if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- helm "$@"
fi

exec "$@"