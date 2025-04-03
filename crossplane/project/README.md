
---

# Crossplane with Argo CD: EKS Cluster and Application Deployment

## Project Overview

This project demonstrates a GitOps approach to deploying cloud-native applications on Amazon Elastic Kubernetes Service (EKS) using Crossplane, Argo CD, and AWS CodeBuild. It encompasses the provisioning of infrastructure, continuous deployment pipelines, and application lifecycle management.

## Repository Structure

The project is organized into five distinct repositories, each serving a specific function:

1. **controlplane**
   - **Purpose**: Deploys the foundational EKS control plane and network infrastructure.
   - **Key Components**:
     - EKS cluster setup
     - Base networking configurations
     - Private Elastic Container Registry (ECR) creation for container image storage

2. **eks-cluster**
   - **Purpose**: Defines Crossplane Compositions and Composite Resource Definitions (XRDs) for EKS cluster deployment.
   - **Key Components**:
     - Crossplane Composition and XRD definitions
     - Nested templates for EKS cluster and network provisioning
     - Crossplane package (`xpkg`) creation and storage in the private ECR repository (`crossplane-ecr`)

3. **appbuild**
   - **Purpose**: Contains the source code and Docker configurations for the application to be built and pushed to ECR.
   - **Key Components**:
     - Application source code
     - Dockerfile for containerization
     - Build scripts and AWS CodeBuild configurations

4. **crossplane-and-argocd**
   - **Purpose**: Sets up Argo CD and Crossplane control plane for continuous deployment and infrastructure management.
   - **Key Components**:
     - Argo CD installation manifests
     - Crossplane installation and configuration
     - Argo CD applications for managing Crossplane AWS provider and configuration deployments
     - Definitions for deploying EKS clusters using Crossplane claim files

5. **appdeployment**
   - **Purpose**: Manages the deployment of the containerized application onto the provisioned EKS cluster using Argo CD.
   - **Key Components**:
     - Kubernetes manifests for application deployment
     - Argo CD application definitions for continuous deployment

## Deployment Workflow

The deployment process follows these steps:

1. **Infrastructure Provisioning**:
   - Use the `controlplane` repository to deploy the base EKS cluster and network infrastructure.
   - Leverage Crossplane configurations from the `eks-cluster` repository to define and provision additional EKS clusters as needed.

2. **Application Build**:
   - Build the application using the resources in the `appbuild` repository.
   - Utilize AWS CodeBuild to automate the building and pushing of the Docker image to the private ECR repository.

3. **Continuous Deployment Setup**:
   - Deploy Argo CD and Crossplane control plane using manifests from the `crossplane-and-argocd` repository.
   - Configure Argo CD applications to manage Crossplane AWS provider, configurations, and EKS deployments.

4. **Application Deployment**:
   - Deploy the containerized application onto the EKS cluster using Argo CD applications defined in the `appdeployment` repository.
   - Ensure continuous deployment and monitoring through Argo CD's GitOps workflows.

## Prerequisites

Before initiating the deployment, ensure the following prerequisites are met:

- **AWS Account**: Active AWS account with necessary permissions.
- **AWS CLI**: Installed and configured with appropriate credentials.
- **kubectl**: Installed for interacting with the Kubernetes cluster.
- **Crossplane CLI**: Installed for managing Crossplane packages and resources.
- **Argo CD CLI**: Installed for interacting with Argo CD.

## Getting Started

To set up and deploy the project:
1. **NAVIGATE TO**: Devops-practice/crossplane/project/
   anik1@Anik-DevOps MINGW64 /crossplane/project
   $ ll
   drwxr-xr-x 1 anik1 197609 0 Apr  3 10:46 Appbuild/
   drwxr-xr-x 1 anik1 197609 0 Apr  3 14:31 appdeployment/
   drwxr-xr-x 1 anik1 197609 0 Apr  3 17:18 controlplane/
   drwxr-xr-x 1 anik1 197609 0 Apr  3 14:17 crossplane-and-argocd/
   drwxr-xr-x 1 anik1 197609 0 Apr  1 22:28 eks-cluster/

2. **Deploy the Control Plane**:
   Navigate to the `controlplane` directory and follow the instructions in its README to deploy the base EKS cluster and network infrastructure.

3. **Define and Provision Additional EKS Clusters**:
   Use the `eks-cluster` repository to define Crossplane Compositions and provision additional EKS clusters as required.

4. **Build and Push the Application**:
   Navigate to the `appbuild` directory and use AWS CodeBuild to build the Docker image and push it to the private ECR repository.

5. **Set Up Argo CD and Crossplane**:
   Use the `crossplane-and-argocd` repository to deploy Argo CD and Crossplane control plane, and configure Argo CD applications for managing deployments.

6. **Deploy the Application**:
   Navigate to the `appdeployment` directory and deploy the application onto the EKS cluster using Argo CD.
