#!/bin/bash

KUBECTLBIN=$(which kubectl)
if [ -z "$KUBECTLBIN" ];
then
  if [ -w "/usr/local/bin" ];
  then
    LOCALBIN="/usr/local/bin"
  else
    mkdir -p ~/.local/bin
    LOCALBIN="~/.local/bin"
  fi

  KUBECTLBIN="${LOCALBIN}/kubectl"
  curl -sSLo "$KUBECTLBIN" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/${ARCH}/kubectl"
  chmod +x "$KUBECTLBIN"
fi

$KUBECTLBIN $@