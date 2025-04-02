#!/bin/bash

# Exit immediately if any command fails
set -e

AWS_ACCOUNT=$1
AWS_REGION=$2

# Create Kubernetes secret for ECR authentication
kubectl create secret docker-registry ecr-secret \
  --namespace crossplane-system \
  --docker-server=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ${AWS_REGION})

echo "✅ ECR secret 'ecr-secret' created successfully in 'crossplane-system' namespace."
