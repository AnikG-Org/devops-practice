###############################################################################################################
# crossplane-eks setup
Manual testing
###############################################################################################################
```shell
#Crossplane cli setup
curl --output crank "https://releases.crossplane.io/stable/current/bin/linux_amd64/crank"
chmod +x crank
sudo mv crank /usr/local/bin/crossplane
###############################################################################################################

anik1@Anik-DevOps MINGW64 crossplane/project/
$ crossplane --version
v1.15.1
```

###############################################################################################################
setup rall providers for crossplane code compositon testing
###############################################################################################################
```shell
anik1@Anik-DevOps MINGW64 crossplane/project
$ cd eks-cluster/crossplane-provider/provider/

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl apply -f upbound-provider-aws-ec2.yaml
provider.pkg.crossplane.io/upbound-provider-aws-ec2 created

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl apply -f upbound-provider-aws-eks.yaml 
provider.pkg.crossplane.io/upbound-provider-aws-eks created

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl apply -f upbound-provider-aws-iam.yaml 
provider.pkg.crossplane.io/upbound-provider-aws-iam created
###########
## make sure update file or CICD or env variable for secret.yaml for creds: $AWS_SECRET_BASE64 of $(cat ~/.aws/credencials)
# apiVersion: v1
# data:
#   creds: $AWS_SECRET_BASE64
###########
anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl apply -f secret.yaml 
Warning: resource secrets/aws-secret is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
secret/aws-secret configured

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl apply -f provider-config-aws.yaml
providerconfig.aws.upbound.io/default created

###############################################################################################################

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl get -f provider-config-aws.yaml
NAME      AGE
default   26s

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster/crossplane-provider/provider
$ kubectl get -f upbound-provider-aws-ec2.yaml 
NAME                       INSTALLED   HEALTHY   PACKAGE                                            AGE
upbound-provider-aws-ec2   True        True      xpkg.upbound.io/upbound/provider-aws-ec2:v1.21.0   11m

###############################################################################################################
#Manual Setup crossplane XRD & composition
###############################################################################################################


anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl apply -f composition-apis/networking/definition.yaml
compositeresourcedefinition.apiextensions.crossplane.io/xnetworkings.net.aws.crossplane.awscommunity.io created

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl apply -f composition-apis/networking/composition.yaml
composition.apiextensions.crossplane.io/networking created

#############################################################################################################
##### test the code
To test the crossplane network composition & XRD testing with example claims

#### update eks claim file with subnet ids
#############################################################################################################

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl apply -f examples/networking/claim.yaml
networking.net.aws.crossplane.awscommunity.io/deploy-target-eks created

###############################################################################################################
anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl get -f examples/networking/claim.yaml
NAME                SYNCED   READY   CONNECTION-SECRET   AGE
deploy-target-eks   True     True                        19m

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl get managed
Warning: BucketPolicy has been deprecated. Use spec.forProvider.policy in Bucket instead.
NAME                                                     SYNCED   READY   EXTERNAL-NAME                       AGE
route.ec2.aws.upbound.io/deploy-target-eks-nxcg6-zxwj8   True     True    r-rtb-00a5b2453adbc84931080289494   17m

NAME                                                               SYNCED   READY   EXTERNAL-NAME           AGE
internetgateway.ec2.aws.upbound.io/deploy-target-eks-nxcg6-fmtfc   True     True    igw-04ad251687f1de7df   17m

NAME                                                                         SYNCED   READY   EXTERNAL-NAME                AGE
mainroutetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-xphs2   True     True    rtbassoc-082be98f96981aa2b   17m

NAME                                                                     SYNCED   READY   EXTERNAL-NAME                AGE
routetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-8w2v4   True     True    rtbassoc-007f9f02f84cbe59e   17m
routetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-gpqhx   True     True    rtbassoc-0018c30ff947d5aaf   17m
routetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-p4kfj   True     True    rtbassoc-05aa77c0ee0bbf074   17m

NAME                                                          SYNCED   READY   EXTERNAL-NAME           AGE
routetable.ec2.aws.upbound.io/deploy-target-eks-nxcg6-bft22   True     True    rtb-00a5b2453adbc8493   17m

NAME                                                                 SYNCED   READY   EXTERNAL-NAME       AGE
securitygrouprule.ec2.aws.upbound.io/deploy-target-eks-nxcg6-6w7s8   True     True    sgrule-1243722912   17m
securitygrouprule.ec2.aws.upbound.io/deploy-target-eks-nxcg6-kkspk   True     True    sgrule-1152197371   17m

NAME                                                 SYNCED   READY   EXTERNAL-NAME          AGE
securitygroup.ec2.aws.upbound.io/deploy-target-eks   True     True    sg-0d73578fc2478a0dd   17m

NAME                                                      SYNCED   READY   EXTERNAL-NAME              AGE
subnet.ec2.aws.upbound.io/deploy-target-eks-nxcg6-mtk84   True     True    subnet-081d9c6522e24da4b   17m
subnet.ec2.aws.upbound.io/deploy-target-eks-nxcg6-pgvb5   True     True    subnet-01eb36fb1351daa27   17m
subnet.ec2.aws.upbound.io/deploy-target-eks-nxcg6-v9bnk   True     True    subnet-0a72844f7c42314fc   17m

NAME                                       SYNCED   READY   EXTERNAL-NAME           AGE
vpc.ec2.aws.upbound.io/deploy-target-eks   True     True    vpc-0775458b551b0219e   17m

#############################################################################################################
##### test the code
To test the Crossplane EKS composition & XRD testing with example claims

#### update eks claim file with subnet ids
#############################################################################################################

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl apply -f examples/eks/claim.yaml
ekscluster.eks.aws.crossplane.awscommunity.io/deploy-target-eks created

#############################################################################################################
anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl get -f examples/eks/claim.yaml
NAME                SYNCED   READY   CONNECTION-SECRET        AGE
deploy-target-eks   True     True    eks-cluster-kubeconfig   13m

anik1@Anik-DevOps MINGW64 crossplane/project/eks-cluster
$ kubectl get crossplane
Warning: BucketPolicy has been deprecated. Use spec.forProvider.policy in Bucket instead.
NAME                                                                                                      ESTABLISHED   OFFERED   AGE
compositeresourcedefinition.apiextensions.crossplane.io/xeksclusters.eks.aws.crossplane.awscommunity.io   True          True      7h4m
compositeresourcedefinition.apiextensions.crossplane.io/xnetworkings.net.aws.crossplane.awscommunity.io   True          True      7h37m

NAME                                                                 REVISION   XR-KIND       XR-APIVERSION                                 AGE
compositionrevision.apiextensions.crossplane.io/aws-eks-8c99411      1          XEKSCluster   eks.aws.crossplane.awscommunity.io/v1alpha1   7h4m
compositionrevision.apiextensions.crossplane.io/networking-3f9bc45   1          XNetworking   net.aws.crossplane.awscommunity.io/v1alpha1   7h37m

NAME                                                 XR-KIND       XR-APIVERSION                                 AGE
composition.apiextensions.crossplane.io/aws-eks      XEKSCluster   eks.aws.crossplane.awscommunity.io/v1alpha1   7h4m
composition.apiextensions.crossplane.io/networking   XNetworking   net.aws.crossplane.awscommunity.io/v1alpha1   7h37m

NAME                                    AGE
providerconfig.aws.upbound.io/default   7h42m

NAME                                                                      AGE     CONFIG-NAME   RESOURCE-KIND               RESOURCE-NAME
providerconfigusage.aws.upbound.io/197bd770-ff92-49ce-9507-c820c06c2ef6   7h19m   default       SecurityGroupRule           deploy-target-eks-nxcg6-kkspk
providerconfigusage.aws.upbound.io/26453904-d88d-43e0-bdb2-9e9b806c55ef   7h19m   default       Route                       deploy-target-eks-nxcg6-zxwj8
providerconfigusage.aws.upbound.io/29121691-ce2f-46d9-a95d-433c57ca09d5   6m43s   default       NodeGroup                   deploy-target-eks-9sll7-zxchc
providerconfigusage.aws.upbound.io/2ba8b2ad-bdf2-4670-9f0a-c688bb4f091f   15m     default       RolePolicyAttachment        deploy-target-eks-9sll7-nt2f8
providerconfigusage.aws.upbound.io/33637a46-829f-4f7e-9b2b-d1c07635bb61   7h19m   default       RouteTableAssociation       deploy-target-eks-nxcg6-8w2v4
providerconfigusage.aws.upbound.io/38be825b-71b1-4719-aad9-6e98f1d616ef   15m     default       RolePolicyAttachment        deploy-target-eks-9sll7-t8nsd
providerconfigusage.aws.upbound.io/507765f9-d67b-4131-a35f-d003b963582b   7h20m   default       SecurityGroup               deploy-target-eks
providerconfigusage.aws.upbound.io/5d0aee5c-ff92-42b5-81b0-8d51a762651b   15m     default       RolePolicyAttachment        deploy-target-eks-9sll7-jcrbv
providerconfigusage.aws.upbound.io/621f91e7-665c-4f1f-9488-7ca938ba443a   7h34m   default       VPC                         deploy-target-eks
providerconfigusage.aws.upbound.io/757f1228-a960-40a1-9dff-ae122af14ec7   15m     default       RolePolicyAttachment        deploy-target-eks-9sll7-cppzb
providerconfigusage.aws.upbound.io/82872b5e-e0ad-454d-bc17-d33700c930bc   7h20m   default       InternetGateway             deploy-target-eks-nxcg6-fmtfc
providerconfigusage.aws.upbound.io/8a9d4d40-4f44-4c60-b240-842e9ddece26   7h20m   default       Subnet                      deploy-target-eks-nxcg6-mtk84
providerconfigusage.aws.upbound.io/8dcc71c8-54b2-4c4c-b549-a1b4e9b77a44   7h19m   default       SecurityGroupRule           deploy-target-eks-nxcg6-6w7s8
providerconfigusage.aws.upbound.io/9c4bc473-de24-43d3-9ac8-d5e1f9024fcd   15m     default       Role                        deploy-target-eks-9sll7-szqc5
providerconfigusage.aws.upbound.io/a112c60e-b7f0-4236-a419-bdea70970f53   6m48s   default       ClusterAuth                 deploy-target-eks-9sll7-jl8n2
providerconfigusage.aws.upbound.io/a8c1accc-b90a-467e-8d58-fdebf24753ca   7h20m   default       Subnet                      deploy-target-eks-nxcg6-pgvb5
providerconfigusage.aws.upbound.io/bdc10def-61e0-461a-8963-2d4d40e4b7d8   7h20m   default       Subnet                      deploy-target-eks-nxcg6-v9bnk
providerconfigusage.aws.upbound.io/d20f0d3a-c0f1-4fd0-9e26-4073f1863159   7h19m   default       RouteTableAssociation       deploy-target-eks-nxcg6-gpqhx
providerconfigusage.aws.upbound.io/da36fd82-e652-4b12-ad91-ab5b22b9b161   7h19m   default       MainRouteTableAssociation   deploy-target-eks-nxcg6-xphs2
providerconfigusage.aws.upbound.io/df8c4f0b-6d04-4746-bb61-bf91ccb31bbb   7h19m   default       RouteTableAssociation       deploy-target-eks-nxcg6-p4kfj
providerconfigusage.aws.upbound.io/e1629764-d34f-494e-8f35-7919c85d3139   7h20m   default       RouteTable                  deploy-target-eks-nxcg6-bft22
providerconfigusage.aws.upbound.io/ea099cfe-c5ef-41f7-aa20-c9cb523306ae   15m     default       Role                        deploy-target-eks-9sll7-6cq4w
providerconfigusage.aws.upbound.io/ee1725c0-4a5c-4c84-a3dc-48b33955d411   15m     default       Cluster                     deploy-target-eks

NAME                                                     SYNCED   READY   EXTERNAL-NAME                     AGE
route.ec2.aws.upbound.io/deploy-target-eks-nxcg6-zxwj8   True     True    rtb-00a5b2453adbc8493_0.0.0.0/0   7h34m

NAME                                                               SYNCED   READY   EXTERNAL-NAME           AGE
internetgateway.ec2.aws.upbound.io/deploy-target-eks-nxcg6-fmtfc   True     True    igw-04ad251687f1de7df   7h34m

NAME                                                                         SYNCED   READY   EXTERNAL-NAME                AGE
mainroutetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-xphs2   True     True    rtbassoc-082be98f96981aa2b   7h34m

NAME                                                                     SYNCED   READY   EXTERNAL-NAME                AGE
routetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-8w2v4   True     True    rtbassoc-007f9f02f84cbe59e   7h34m
routetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-gpqhx   True     True    rtbassoc-0018c30ff947d5aaf   7h34m
routetableassociation.ec2.aws.upbound.io/deploy-target-eks-nxcg6-p4kfj   True     True    rtbassoc-05aa77c0ee0bbf074   7h34m

NAME                                                          SYNCED   READY   EXTERNAL-NAME           AGE
routetable.ec2.aws.upbound.io/deploy-target-eks-nxcg6-bft22   True     True    rtb-00a5b2453adbc8493   7h34m

NAME                                                                 SYNCED   READY   EXTERNAL-NAME       AGE
securitygrouprule.ec2.aws.upbound.io/deploy-target-eks-nxcg6-6w7s8   True     True    sgrule-1243722912   7h34m
securitygrouprule.ec2.aws.upbound.io/deploy-target-eks-nxcg6-kkspk   True     True    sgrule-1152197371   7h34m

NAME                                                 SYNCED   READY   EXTERNAL-NAME          AGE
securitygroup.ec2.aws.upbound.io/deploy-target-eks   True     True    sg-0d73578fc2478a0dd   7h34m

NAME                                                      SYNCED   READY   EXTERNAL-NAME              AGE
subnet.ec2.aws.upbound.io/deploy-target-eks-nxcg6-mtk84   True     True    subnet-081d9c6522e24da4b   7h34m
subnet.ec2.aws.upbound.io/deploy-target-eks-nxcg6-pgvb5   True     True    subnet-01eb36fb1351daa27   7h34m
subnet.ec2.aws.upbound.io/deploy-target-eks-nxcg6-v9bnk   True     True    subnet-0a72844f7c42314fc   7h34m

NAME                                       SYNCED   READY   EXTERNAL-NAME           AGE
vpc.ec2.aws.upbound.io/deploy-target-eks   True     True    vpc-0775458b551b0219e   7h34m

NAME                                           SYNCED   READY   EXTERNAL-NAME       AGE
cluster.eks.aws.upbound.io/deploy-target-eks   True     True    deploy-target-eks   15m

NAME                                                         SYNCED   READY   EXTERNAL-NAME                   AGE
nodegroup.eks.aws.upbound.io/deploy-target-eks-9sll7-zxchc   True     True    deploy-target-eks-9sll7-zxchc   15m

NAME                                                           SYNCED   READY   EXTERNAL-NAME                   AGE
clusterauth.eks.aws.upbound.io/deploy-target-eks-9sll7-jl8n2   True     True    deploy-target-eks-9sll7-jl8n2   15m

NAME                                                                    SYNCED   READY   EXTERNAL-NAME                                              AGE
rolepolicyattachment.iam.aws.upbound.io/deploy-target-eks-9sll7-cppzb   True     True    deploy-target-eks-9sll7-6cq4w-20250401023825426000000002   15m
rolepolicyattachment.iam.aws.upbound.io/deploy-target-eks-9sll7-jcrbv   True     True    deploy-target-eks-9sll7-6cq4w-20250401023825547100000003   15m
rolepolicyattachment.iam.aws.upbound.io/deploy-target-eks-9sll7-nt2f8   True     True    deploy-target-eks-9sll7-6cq4w-20250401023825334700000001   15m
rolepolicyattachment.iam.aws.upbound.io/deploy-target-eks-9sll7-t8nsd   True     True    deploy-target-eks-9sll7-szqc5-20250401023825653900000004   15m

NAME                                                    SYNCED   READY   EXTERNAL-NAME                   AGE
role.iam.aws.upbound.io/deploy-target-eks-9sll7-6cq4w   True     True    deploy-target-eks-9sll7-6cq4w   15m
role.iam.aws.upbound.io/deploy-target-eks-9sll7-szqc5   True     True    deploy-target-eks-9sll7-szqc5   15m

NAME                                                                          HEALTHY   REVISION   IMAGE                                                     STATE    DEP-FOUND   DEP-INSTALLED   AGE
providerrevision.pkg.crossplane.io/provider-aws-d244380f5072                  True      1          xpkg.upbound.io/crossplane-contrib/provider-aws:v0.52.0   Active                               3d7h
providerrevision.pkg.crossplane.io/upbound-provider-aws-ec2-21aa53711e54      True      1          xpkg.upbound.io/upbound/provider-aws-ec2:v1.21.0          Active   1           1               7h52m
providerrevision.pkg.crossplane.io/upbound-provider-aws-eks-bb7c5469ebb3      True      1          xpkg.upbound.io/upbound/provider-aws-eks:v1.21.0          Active   1           1               7h52m
providerrevision.pkg.crossplane.io/upbound-provider-aws-iam-78efa8cce6df      True      1          xpkg.upbound.io/upbound/provider-aws-iam:v1.21.0          Active   1           1               7h52m
providerrevision.pkg.crossplane.io/upbound-provider-family-aws-9c2ce8bc65e7   True      1          xpkg.upbound.io/upbound/provider-family-aws:v1.21.1       Active                               7h52m

NAME                                                     INSTALLED   HEALTHY   PACKAGE                                                   AGE
provider.pkg.crossplane.io/provider-aws                  True        True      xpkg.upbound.io/crossplane-contrib/provider-aws:v0.52.0   3d7h
provider.pkg.crossplane.io/upbound-provider-aws-ec2      True        True      xpkg.upbound.io/upbound/provider-aws-ec2:v1.21.0          7h52m
provider.pkg.crossplane.io/upbound-provider-aws-eks      True        True      xpkg.upbound.io/upbound/provider-aws-eks:v1.21.0          7h52m
provider.pkg.crossplane.io/upbound-provider-aws-iam      True        True      xpkg.upbound.io/upbound/provider-aws-iam:v1.21.0          7h52m
provider.pkg.crossplane.io/upbound-provider-family-aws   True        True      xpkg.upbound.io/upbound/provider-family-aws:v1.21.1       7h52m

NAME                                                AGE
deploymentruntimeconfig.pkg.crossplane.io/default   6d20h

NAME                                        AGE     TYPE         DEFAULT-SCOPE
storeconfig.secrets.crossplane.io/default   6d20h   Kubernetes   crossplane-system
```
#############################################################################################################
To extract the EKS cluster kubeconfig:
```shell
kubectl get secret eks-cluster-kubeconfig -o jsonpath='{.data.kubeconfig}' | base64 --decode > ekskubeconfig
Now integrate the contents of the ekskubeconfig file into your ~/.kube/config (better with VSCode!) and switch over to the new kube context
```
#############################################################################################################
Create a controlplane ECR before build push: 
#############################################################################################################
```shell
anik1@Anik-DevOps MINGW64 crossplane/controlplane/provider
$ kubectl apply -f secret.yaml 
secret/aws-secret created

anik1@Anik-DevOps MINGW64 crossplane/controlplane/provider
$ kubectl apply -f provider.yaml 
provider.pkg.crossplane.io/provider-aws unchanged

anik1@Anik-DevOps MINGW64 crossplane/controlplane/provider
$ kubectl apply -f providerconfig.yaml 
providerconfig.aws.crossplane.io/crossplane-aws created

anik1@Anik-DevOps MINGW64 crossplane/controlplane/eks
$ kubectl apply -f iamrole.yaml 
role.iam.aws.crossplane.io/iamroleforeks created
policy.iam.aws.crossplane.io/eks-custom-policy created
rolepolicyattachment.iam.aws.crossplane.io/s3readaccessattachment created
rolepolicyattachment.iam.aws.crossplane.io/customeksaccessattachment created
rolepolicyattachment.iam.aws.crossplane.io/ecraccessattachment created
rolepolicyattachment.iam.aws.crossplane.io/ec2accessattachment created

anik1@Anik-DevOps MINGW64 crossplane/controlplane/eks
$ kubectl apply -f ecr.yaml 
repository.ecr.aws.crossplane.io/crossplane-ecr created
repositorypolicy.ecr.aws.crossplane.io/ecradmin created
lifecyclepolicy.ecr.aws.crossplane.io/crossplane-ecr-lcp created

#############################################################################################################
anik1@Anik-DevOps MINGW64 crossplane/controlplane/eks
$ kubectl get -f ecr.yaml 
NAME                                              READY   SYNCED   ID               URI
repository.ecr.aws.crossplane.io/crossplane-ecr   True    True     crossplane-ecr   309272221538.dkr.ecr.ap-south-1.amazonaws.com/crossplane-ecr

NAME                                              READY   SYNCED   ID
repositorypolicy.ecr.aws.crossplane.io/ecradmin   True    True     ecradmin

NAME                                                       READY   SYNCED   EXTERNAL-NAME        AGE
lifecyclepolicy.ecr.aws.crossplane.io/crossplane-ecr-lcp   True    True     crossplane-ecr-lcp   103s

```
#############################################################################################################
Building a Configuration Package as OCI container

crossplane xpkg build --package-root=. --examples-root="./examples" --ignore="crossplane-provider/install/*,crossplane-provider/provider/*" --verbose
#############################################################################################################
```shell
anik@Anik-DevOps:~$ cd eks-cluster/
anik@Anik-DevOps:~/eks-cluster$ crossplane xpkg build --package-root=. --examples-root="./examples" --ignore="crossplane-provider/install/*,crossplane-provider/provider/*,build*" --verbose
2025-04-01T09:08:27Z    INFO    xpkg saved      {"output": "/home/anik/eks-cluster/crossplane-eks-cluster-fa60142b580b.xpkg"}
anik@Anik-DevOps:~/eks-cluster$
```

#############################################################################################################
Login to ECR
#############################################################################################################
```shell
anik@Anik-DevOps:~/eks-cluster$ aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 309272221538.dkr.ecr.ap-south-1.amazonaws.com
Login Succeeded
```
#############################################################################################################
OCI image push to ECR
#############################################################################################################

```shell
anik@Anik-DevOps:~/eks-cluster$ crossplane xpkg push 309272221538.dkr.ecr.ap-south-1.amazonaws.com/crossplane-ecr:latest --verbose
2025-04-01T10:21:22Z    DEBUG   Found package in directory      {"path": "crossplane-eks-cluster-48f66f345fe8.xpkg"}
2025-04-01T10:21:22Z    DEBUG   Supplied server URL is not supported by this credentials helper {"serverURL": "309272221538.dkr.ecr.ap-south-1.amazonaws.com", "domain": "upbound.io"}
2025-04-01T10:21:25Z    DEBUG   Pushed package  {"path": "crossplane-eks-cluster-48f66f345fe8.xpkg", "ref": "309272221538.dkr.ecr.ap-south-1.amazonaws.com/crossplane-ecr:latest"}
anik@Anik-DevOps:~/eks-cluster$
#############################################################################################################
```
## use buildspec yaml to automate the entire build