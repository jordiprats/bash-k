#!/bin/sh

linux_arch() {
  if [ -z "$(which dpkg)" ] 2>/dev/null; 
  then
    case "$(arch)" in
      aarch64) ARCH="arm64";;
      x86_64)  ARCH="amd64";;
    esac
  else 
    ARCH=$(dpkg --print-architecture)
  fi
}

KUBECTLBIN=$(which kubectl) 2>/dev/null
if [ -z "$KUBECTLBIN" ];
then
  if [ -w "/usr/local/bin" ];
  then
    LOCALBIN="/usr/local/bin"
  else
    mkdir -p "$HOME/.local/bin"
    LOCALBIN="$HOME/.local/bin"
  fi

  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "${OS}" in
      linux*)     linux_arch;;
      darwin*)    ARCH=$(uname -m);;
      *)          echo "error retrieving arch"; exit 1;;
  esac

  if [ -z "$KUBECTL_VERSION" ];
  then
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
  fi

  KUBECTLBIN="${LOCALBIN}/kubectl"
  curl -sSLo "$KUBECTLBIN" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/${ARCH}/kubectl"
  chmod +x "$KUBECTLBIN"
fi

$KUBECTLBIN $@