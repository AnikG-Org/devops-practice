#!/bin/bash

deploy_environment=$1
kube_context=$2
source ~/.profile
export VAULT_ADDR=https://vault-us.pocinternal.com
export VAULT_NAMESPACE=xlos/poclabs/ai-platform
export VAULT_SKIP_VERIFY=true

VAULT_SERVER="https://vault-us.pocinternal.com"

INSTANCE_METADATA=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-12-01");
SCALE_SET_NAME=$(echo $INSTANCE_METADATA | jq .compute.name | sed 's/"//g');
SUBSCRIPTION_ID=$(echo $INSTANCE_METADATA | jq .compute.subscriptionId | sed 's/"//g');
RESOURCE_GROUP_NAME=$(echo $INSTANCE_METADATA | jq .compute.resourceGroupName | sed 's/"//g');

AZURE_JWT=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' -H Metadata:true | jq .access_token | sed 's/"//g');

TOKEN_REQUEST_PAYLOAD="{\"role\":\"common\", \"jwt\":\"$AZURE_JWT\",\"subscription_id\":\"$SUBSCRIPTION_ID\", \"resource_group_name\":\"$RESOURCE_GROUP_NAME\", \"vm_name\":\"$SCALE_SET_NAME\" }";

export VAULT_TOKEN=$(curl --insecure --request POST -H "X-Vault-Namespace: xlos/poclabs/ai-platform" --data "$TOKEN_REQUEST_PAYLOAD" "$VAULT_SERVER/v1/auth/azure/login" | jq '.auth.client_token' | sed 's/"//g');
vault kv get -format=json $deploy_environment/$kube_context > secret.json
yq -y .data secret.json  > env/vault/$kube_context.yaml

###### added below command to use environment specific regcred  #######

vault kv get -format=yaml $deploy_environment/regcred >regcred.yaml
echo "ai_registry_secret:" >> env/vault/$kube_context.yaml
yq -r .data.ai_registry_secret regcred.yaml  >> env/vault/$kube_context.yaml

vault kv get -format=yaml $deploy_environment/artifactwestregcred >artifactwestregcred.yaml
echo "ai_registry_west_secret:" >> env/vault/$kube_context.yaml
yq -r .data.ai_registry_west_secret artifactwestregcred.yaml  >> env/vault/$kube_context.yaml