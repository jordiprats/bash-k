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

  OS=$(uname -s | tr [A-Z] [a-z])
  case "${OS}" in
      linux*)     ARCH=$(dpkg --print-architecture);;
      darwin*)    ARCH=$(uname -m);;
      *)          echo "error retrieving arch"; exit 1;;
  esac

  KUBECTLBIN="${LOCALBIN}/kubectl"
  curl -sSLo "$KUBECTLBIN" "https://storage.googleapis.com/kubernetes-release/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${ARCH}/kubectl"
  chmod +x "$KUBECTLBIN"
fi

$KUBECTLBIN $@