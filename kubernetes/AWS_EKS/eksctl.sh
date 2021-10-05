#https://github.com/stacksimplify/aws-eks-kubernetes-masterclass
#install kubectl [1] & eksctl [2] with aws rendering binary:
[1] https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
[2] https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl

# Create EKS Cluster[cluster --name=eksdemo1] using eksctl #by default it creates in public
eksctl create cluster --name=eksdemo1 \
                      --region=us-east-1 \
                      #--zones=us-east-1a,us-east-1b \
                      --tags environment=dev \
                      --resources-vpc-config subnetIds=subnet-1,subnet-2,securitygroupIds=sg-1 \
                      --rolw-arn arn:***
                      --without-nodegroup 

# Get List of clusters
eksctl get clusters 
-------
#To enable all types of logs, run:
eksctl utils update-cluster-logging --enable-types all
#To enable audit logs, run:
eksctl utils update-cluster-logging --enable-types audit
#To enable all but controllerManager logs, run:
eksctl utils update-cluster-logging --enable-types=all --disable-types=controllerManager
#To disable all types of logs, run:
eksctl utils update-cluster-logging --disable-types all
--------
#Create & Associate IAM OIDC Provider for our EKS Cluster # Replaced with region & cluster name
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster eksdemo1 \
    --approve
#Create EC2 Keypair from console #EC2 Keypair with name as kube-demo
#Create Node Group with additional Add-Ons in custom Public/pub Subnets
eksctl create nodegroup --cluster=eksdemo1 \
                       --region=us-east-1 \
                       --name=eksdemo1-ng-public1 \
                       --tags environment=dev \
                       --node-type=t3.medium \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=kube-demo \
                       --managed \
                       --enable-ssm \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access 
#Create Private Node Group in a Cluster | Key option for the command is --node-private-networking
eksctl create nodegroup --cluster=eksdemo1 \
                        --region=us-east-1 \
                        --name=eksdemo1-ng-private1 \
                        --tags environment=dev \
                        --node-type=t3.medium \
                        --nodes-min=2 \
                        --nodes-max=4 \
                        --node-volume-size=20 \
                        --ssh-access \
                        --ssh-public-key=kube-demo \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access \
                        --node-private-networking  

--------
# List EKS clusters
eksctl get cluster
# List NodeGroups in a cluster
eksctl get nodegroup --cluster=<clusterName>
# List Nodes in current kubernetes cluster
kubectl get nodes -o wide
# Our kubectl context should be automatically changed to new cluster
kubectl config view --minify
--------
#Delete Node Group
eksctl delete nodegroup --cluster=<clusterName> --name=<nodegroupName>
# Delete Cluster
eksctl delete cluster <clusterName>
---
#Create an IAM role for the ALB Ingress Controller and attach the role to the service account
# Template
# Replaced region, name, cluster and policy arn (Policy arn we took note in step-03)
eksctl create iamserviceaccount \
    --region us-east-1 \
    --name alb-ingress-controller \         #Note:  K8S Service Account Name[alb-ingress-controller] that need to be bound to newly created IAM Role
    --namespace kube-system \
    --cluster eksdemo1 \
    --attach-policy-arn arn:aws:iam::180789647333:policy/ALBIngressControllerIAMPolicy \        #created ALBIngressControllerIAMPolicy IAM Policy ARN
    --override-existing-serviceaccounts \
    --approve
