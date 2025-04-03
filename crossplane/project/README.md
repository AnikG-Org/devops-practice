Crossplane with Argocd - Eks cluster and application build deployment 

Project Overview

This project showcases a GitOps approach to deploying a cloud-native application on Amazon Elastic Container Service for Kubernetes (EKS) using Crossplane, Argo CD, and AWS CodeBuild.

Repository Structure
The project consists of five separate repositories:

*1. controlplane*
- Deploys the base control plane EKS cluster and base network
- Sets up a private ECR repository for storing container images

*2. eks-cluster*
- Defines Crossplane Composition, XRD, and nested templates for deploying EKS clusters with base network setup
- Builds a Crossplane xpkg package for the nested Composition and stores it in the private ECR crossplane-ecr repository

*3. appbuild*
- Contains a Docker application to be built and pushed to the ECR crossplane-app repository

*4. crossplane-and-argocd*
- Includes Argo CD packages for setting up Argo CD and Crossplane control plane
- Defines an Argo CD application for managing Crossplane AWS provider and configuration deployments, as well as Crossplane EKS deployments using claim files

*5. appdeployment*
- Contains deployment manifests to be deployed using the Argo CD application from the crossplane-and-argocd repository

GitOps Workflow
The entire process is automated using a GitOps approach with Argo CD and AWS CodeBuild:

1. Code changes are pushed to the respective repositories.
2. AWS CodeBuild triggers a build process for the updated code.
3. The built container images are pushed to the private ECR repositories.
4. Argo CD detects changes in the repositories and automatically deploys the updated applications to the EKS cluster.

Getting Started
To replicate this project, follow these steps:

1. Clone the respective repositories.
2. Set up your AWS environment, including EKS clusters and ECR repositories.
3. Configure Argo CD and Crossplane.
4. Update the deployment manifests and push changes to the repositories.
5. Allow Argo CD to automatically deploy the updated applications.

