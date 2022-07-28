#!/bin/ash

RELEASE=$1
IFS='/'
read -r REPO PACKAGE <<EOF
$2
EOF
unset IFS
SETKEY=$3
SETVAL=$4
GHTOKEN=$5
B64KCONFIG=$6

mkdir -p ~/.kube
echo "$B64KCONFIG" | base64 -d > ~/.kube/config
chmod 600 ~/.kube/config
export KUBECONFIG=

helm repo add $REPO \
  --username "$GHTOKEN" \
  --password "$GHTOKEN" \
  "https://raw.githubusercontent.com/$REPO/$PACKAGE/main/"

helm repo update

echo "Upgrading release '$RELEASE' with '$REPO/$PACKAGE' and setting $SETKEY=$SETVAL..."
helm upgrade --install --set $SETKEY=$SETVAL $RELEASE $REPO/$PACKAGE
