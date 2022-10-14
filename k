#!/bin/bash

linux_arch {
  if [ -z "$(which dpkg)" ]; 
  then
    if [ "$(arch)" == "x86_64" ];
    then
      ARCH="amd64"
    else 
      ARCH="$(arch)"
    fi
  else 
    ARCH=$(dpkg --print-architecture)
  fi
}

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
      linux*)     linux_arch;;
      darwin*)    ARCH=$(uname -m);;
      *)          echo "error retrieving arch"; exit 1;;
  esac

  KUBECTLBIN="${LOCALBIN}/kubectl"
  curl -sSLo "$KUBECTLBIN" "https://storage.googleapis.com/kubernetes-release/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${OS}/${ARCH}/kubectl"
  chmod +x "$KUBECTLBIN"
fi

$KUBECTLBIN $@