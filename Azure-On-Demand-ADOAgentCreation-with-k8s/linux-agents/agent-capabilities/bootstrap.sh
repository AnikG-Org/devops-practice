#!/bin/bash
set -euo pipefail

## List of the packages to be list with apt-get ##
declare -a pck=("software-properties-common" 
                "python3-setuptools"
                "r-base" 
                "google-cloud-sdk" 
                "openjdk-8-jre" 
                "openjdk-8-jdk"
                "python3-selinux" 
                "python3-pip" 
                "yarn" 
                "maven" 
                "apt-transport-https" 
                "kubectl=1.19.7-00" 
                "vault=1.5.4"
                "azure-functions-core-tools-3")


## Variable list for various downloadables ##

GCLOUD="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
HELM="https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"
KUSTOMIZE="https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"
YARN="https://dl.yarnpkg.com/debian/pubkey.gpg"
KUBECTL="https://packages.cloud.google.com/apt/doc/apt-key.gpg"
CORTEX="https://github.com/grafana/cortex-tools/releases/download/v0.9.0/cortextool_0.9.0_linux_x86_64"
VAULT="https://apt.releases.hashicorp.com/gpg"
AZ_FUNC="https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb"

## Download required Binaries ##
echo "gcloud"
curl $GCLOUD | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

echo "kustomize"
curl -s $KUSTOMIZE  | bash

echo "Helm"
curl -fsSL -o get_helm.sh  $HELM && chmod 700 get_helm.sh && ./get_helm.sh -v v3.3.0 && ln -s /usr/local/bin/helm /usr/local/bin/helm3

echo "cortex"
curl -fSL -o "/usr/local/bin/cortextool" $CORTEX && chmod a+x "/usr/local/bin/cortextool" && cortextool --help
echo $?

echo "kubectl"
curl -s $KUBECTL | apt-key add -

echo "yarn"
curl -sS $YARN | apt-key add -

echo "vault"
curl -fsSL $VAULT | apt-key add -

echo "az-func"
wget -q $AZ_FUNC && dpkg -i packages-microsoft-prod.deb

## Setting up necessary repositories ##
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
echo "deb [arch=amd64] https://apt.releases.hashicorp.com bionic main" | tee -a /etc/apt/sources.list

## Installing JupyterHub ##
alias helm3='helm'
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

## Installing the apt-get packages listed above ##
for i in "${pck[@]}"
do
   echo "$i"
   apt-get update &&
   apt-get install -y --no-install-recommends "$i"
   echo "Install packages"
   rm -rf /var/lib/apt/lists/*
done

## Setting JavaHome ##
echo "export JAVA_HOME=$(readlink -f $(which java))" > /etc/profile.d/java.sh
source /etc/profile

## Installing Vault 1.5 ##
setcap cap_ipc_lock= /usr/bin/vault

## Installing Ansible 2.10 ##
add-apt-repository --yes --update ppa:ansible/ansible-2.10
apt install ansible