# crossplane-argocd

Pproject showing how to use the crossplane together with ArgoCD

### TLDR: Steps from 0 to 100

If you don't want to read much text, do the following steps:

```shell

# Install ArgoCD
kubectl apply -k argocd/install

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --namespace argocd --timeout=300s

# Access ArgoUI
kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8080:80
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo


# Prepare Secret with ArgoCD API Token for Crossplane ArgoCD Provider (port forward can be run in subshell appending ' &' + Ctrl-C and beeing deleted after running create-argocd-api-token-secret.sh via 'fg 1%' + Ctrl-C)
kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8443:443




# Bootstrap Crossplane via ArgoCD
kubectl apply -n argocd -f argocd/crossplane-eso-bootstrap.yaml 

kubectl get crd

# Install Crossplane EKS APIs/Composition
kubectl apply -f argocd/crossplane-apis/crossplane-apis.yaml

# Create actual EKS cluster via Crossplane & register it in ArgoCD via argocd-provider
kubectl apply -f argocd/infrastructure/aws-eks.yaml
crossplane beta trace kubernetesclusters.k8s.crossplane.jonashackt.io/deploy-target-eks -o wide

# Optional: If you want, have a look onto the new cluster
kubectl get secret eks-cluster-kubeconfig -o jsonpath='{.data.kubeconfig}' | base64 --decode > ekskubeconfig
# integrate the contents of `ekskubeconfig` into your `~/.kube/config` (better w/ VSCode!) & switch over to the new kube context

# Run Application on EKS cluster using Argo
kubectl apply -f argocd/applications/microservice-api-spring-boot.yaml
```

Now you should see both clusters (kind & EKS) running and the app beeing deployed:

![](docs/kind-argo-crossplane-and-eks-fully-working.png)



# Prerequisites: a management cluster for ArgoCD and crossplane

First we need a simple management cluster for our ArgoCD and crossplane deployments. [As in the base project](https://github.com/jonashackt/crossplane-aws-azure) we simply use kind here:

Be sure to have some packages installed.:

```shell
sudo apt update && sudo apt install -y curl apt-transport-https

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

# Install Kind
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64"
chmod +x kind && sudo mv kind /usr/local/bin/

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Kustomize
curl -s "https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest" | \
  grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4 | xargs curl -LO
mv kustomize_*_linux_amd64 kustomize
chmod +x kustomize && sudo mv kustomize /usr/local/bin/

# Install ArgoCD
curl -sSL -o argocd "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
chmod +x argocd && sudo mv argocd /usr/local/bin/
```

```shell
curl --output crank "https://releases.crossplane.io/stable/current/bin/linux_amd64/crank"
chmod +x crank
sudo mv crank /usr/local/bin/crossplane
```

Now the `kubectl crossplane --help` command should be ready to use


# Install ArgoCD into the management cluster

Using [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) enables a great way of declaritively changing configuration in ConfigMaps, while using the default installation method (which [is this install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)). 


Now we have everything prepared to install ArgoCD via Kustomize. Simply run a `kubectl apply -k` :

```shell
kubectl apply -k argocd/install


##################################
anik@Anik-DevOps:/mnt/crossplane/project/crossplane-and-argocd$ kubectl apply -k argocd/install
Warning: resource namespaces/argocd is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
namespace/argocd configured
Warning: resource customresourcedefinitions/applications.argoproj.io is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io configured
Warning: resource customresourcedefinitions/applicationsets.argoproj.io is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
customresourcedefinition.apiextensions.k8s.io/applicationsets.argoproj.io configured
Warning: resource customresourcedefinitions/appprojects.argoproj.io is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
customresourcedefinition.apiextensions.k8s.io/appprojects.argoproj.io configured
serviceaccount/argocd-application-controller created
serviceaccount/argocd-applicationset-controller created
serviceaccount/argocd-dex-server created
serviceaccount/argocd-notifications-controller created
serviceaccount/argocd-redis created
serviceaccount/argocd-repo-server created
serviceaccount/argocd-server created
role.rbac.authorization.k8s.io/argocd-application-controller created
role.rbac.authorization.k8s.io/argocd-applicationset-controller created
role.rbac.authorization.k8s.io/argocd-dex-server created
role.rbac.authorization.k8s.io/argocd-notifications-controller created
role.rbac.authorization.k8s.io/argocd-redis created
role.rbac.authorization.k8s.io/argocd-server created
clusterrole.rbac.authorization.k8s.io/argocd-application-controller created
clusterrole.rbac.authorization.k8s.io/argocd-applicationset-controller created
clusterrole.rbac.authorization.k8s.io/argocd-server created
rolebinding.rbac.authorization.k8s.io/argocd-application-controller created
rolebinding.rbac.authorization.k8s.io/argocd-applicationset-controller created
rolebinding.rbac.authorization.k8s.io/argocd-dex-server created
rolebinding.rbac.authorization.k8s.io/argocd-notifications-controller created
rolebinding.rbac.authorization.k8s.io/argocd-redis created
rolebinding.rbac.authorization.k8s.io/argocd-server created
clusterrolebinding.rbac.authorization.k8s.io/argocd-application-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-applicationset-controller created
clusterrolebinding.rbac.authorization.k8s.io/argocd-server created
configmap/argocd-cm created
configmap/argocd-cmd-params-cm created
configmap/argocd-gpg-keys-cm created
configmap/argocd-notifications-cm created
configmap/argocd-rbac-cm created
configmap/argocd-ssh-known-hosts-cm created
configmap/argocd-tls-certs-cm created
secret/argocd-notifications-secret created
secret/argocd-secret created
service/argocd-applicationset-controller created
service/argocd-dex-server created
service/argocd-metrics created
service/argocd-notifications-controller-metrics created
service/argocd-redis created
service/argocd-repo-server created
service/argocd-server created
service/argocd-server-metrics created
deployment.apps/argocd-applicationset-controller created
deployment.apps/argocd-dex-server created
deployment.apps/argocd-notifications-controller created
deployment.apps/argocd-redis created
deployment.apps/argocd-repo-server created
deployment.apps/argocd-server created
statefulset.apps/argocd-application-controller created
networkpolicy.networking.k8s.io/argocd-application-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-applicationset-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-dex-server-network-policy created
networkpolicy.networking.k8s.io/argocd-notifications-controller-network-policy created
networkpolicy.networking.k8s.io/argocd-redis-network-policy created
networkpolicy.networking.k8s.io/argocd-repo-server-network-policy created
networkpolicy.networking.k8s.io/argocd-server-network-policy created

anik@Anik-DevOps:/mnt/crossplane/project/crossplane-and-argocd$ kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --namespace argocd --timeout=300s
pod/argocd-server-785958d7fc-gkq2l condition met
anik@Anik-DevOps:/mnt/crossplane/project/crossplane-and-argocd$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
xxxxxxxxxx-XV9xxzy

#In order to make the `argocd-server` available outside of our management cluster we have multiple options. One of the simplest might be a `port-forward`:

anik@Anik-DevOps:/mnt/crossplane/project/crossplane-and-argocd$  kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8080:80
Forwarding from 0.0.0.0:8080 -> 8080
Handling connection for 8080
Handling connection for 8080

##################################
```
#Alternative
```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ helm install argocd-demo argo/argo-cd --namespace argocd
NAME: argocd-demo
LAST DEPLOYED: Wed Apr  2 10:08:06 2025
NAMESPACE: argocd
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
In order to access the server UI you have the following options:

1. kubectl port-forward service/argocd-demo-server -n argocd 8080:443

    and then open the browser on http://localhost:8080 and accept the certificate

2. enable ingress in the values file `server.ingress.enabled` and either
      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
      - Set the `configs.params."server.insecure"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts


After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```


#Use a NodePort (For On-Prem or Minikube/KIND)

```shell
anik@Anik-DevOps:/mnt/crossplane/project/crossplane-and-argocd# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
service/argocd-server patched
anik@Anik-DevOps:/mnt/crossplane/project/crossplane-and-argocd$ kubectl get svc -n argocd | grep argocd-server
argocd-server                             NodePort    10.106.36.164    <none>        80:32366/TCP,443:30431/TCP   13m
```

### Accessing ArgoCD GUI


Now we can access the ArgoCD UI inside your Browser at http://localhost:32366 using `admin` user and the obtained password.



### Login ArgoCD CLI into our argocd-server installed in kind

https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli

In order to be able to add applications to Argo, we should login our ArgoCD CLI into our `argocd-server` installed:

```shell
anik1@Anik-DevOps 
$ argocd login localhost:8080 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure
'admin:login' logged in successfully
Context 'localhost:8080' updated

```

Remember to change the initial password in production environments!




# Let ArgoCD install Crossplane

Is it possible to already use the GitOps approach right from here on to install crossplane? Let's try it.

```yaml
apiVersion: v2
type: application
name: crossplane-argocd
version: 0.0.0 # unused
appVersion: 0.0.0 # unused
dependencies:
  - name: crossplane
    repository: https://charts.crossplane.io/stable
    version: 1.16.0
```

__This Helm chart needs to be picked up by Argo in a declarative GitOps way (not through the UI).__



```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -f argocd/crossplane-bootstrap/crossplane-helm-secret.yaml
secret/crossplane-helm-repo created

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -n argocd -f argocd/crossplane-bootstrap/crossplane.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/crossplane created
```

Just have a look into Argo UI.

We can double check everything is there on the command line via:

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl get all -n crossplane-system
NAME                                                            READY   STATUS    RESTARTS        AGE
pod/crossplane-8676c674b6-8mwmg                                 1/1     Running   0               6m47s
pod/crossplane-rbac-manager-845ff686b4-nt4r9                    1/1     Running   0               6m47s
pod/provider-aws-d244380f5072-7d59d49449-5v2h2                  1/1     Running   0               92m
pod/upbound-provider-family-aws-9c2ce8bc65e7-5698b576d4-gbbrs   1/1     Running   4 (3h11m ago)   35h

NAME                                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/crossplane-webhooks           ClusterIP   10.103.35.229    <none>        9443/TCP   8d
service/provider-aws                  ClusterIP   10.97.191.34     <none>        9443/TCP   92m
service/upbound-provider-family-aws   ClusterIP   10.108.240.131   <none>        9443/TCP   35h

NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/crossplane                                 1/1     1            1           8d
deployment.apps/crossplane-rbac-manager                    1/1     1            1           8d
deployment.apps/provider-aws-d244380f5072                  1/1     1            1           92m
deployment.apps/upbound-provider-family-aws-9c2ce8bc65e7   1/1     1            1           35h

NAME                                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/crossplane-654d5644f4                                 0         0         0       8d
replicaset.apps/crossplane-8676c674b6                                 1         1         1       6m47s
replicaset.apps/crossplane-rbac-manager-59d8fcb968                    0         0         0       8d
replicaset.apps/crossplane-rbac-manager-845ff686b4                    1         1         1       6m47s
replicaset.apps/provider-aws-d244380f5072-7d59d49449                  1         1         1       92m
replicaset.apps/upbound-provider-family-aws-9c2ce8bc65e7-5698b576d4   1         1         1       35h
```
                               

### Create aws-creds.conf file & create AWS Provider secret

https://docs.crossplane.io/latest/getting-started/provider-aws/#generate-an-aws-key-pair-file

I assume here that you have [aws CLI installed and configured](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). So that the command `aws configure` should work on your system. With this prepared we can create an `aws-creds.conf` file:

```shell
echo "[default]
aws_access_key_id = $(aws configure get aws_access_key_id)
aws_secret_access_key = $(aws configure get aws_secret_access_key)
" > aws-creds.conf
```

> Don't ever check this file into source control - it holds your AWS credentials! For this repository I added `*-creds.conf` to the [.gitignore](.gitignore) file. 


Now we need to use the `aws-creds.conf` file to create the Crossplane AWS Provider secret:

```shell
kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./aws-creds.conf 
or
nik1@Anik-DevOps MINGW64 ~/.aws
$ kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=/c/Users/anik1/.aws/credentials
secret/aws-creds created

anik1@Anik-DevOps MINGW64 ~/.aws
$ kubectl get secret -n crossplane-system
NAME                                     TYPE                 DATA   AGE
aws-creds                                Opaque               1      18s
aws-secret                               Opaque               1      109m
crossplane-root-ca                       Opaque               2      8d
crossplane-tls-client                    Opaque               3      8d
crossplane-tls-server                    Opaque               3      8d
provider-aws-tls-client                  Opaque               3      108m
provider-aws-tls-server                  Opaque               3      108m
sh.helm.release.v1.crossplane.v1         helm.sh/release.v1   1      8d
upbound-provider-family-aws-tls-client   Opaque               3      36h
upbound-provider-family-aws-tls-server   Opaque               3      36h

```



### Install crossplane's AWS provider with ArgoCD

Let's apply this `Application` to our cluster also:

```shell
anik1@Anik-DevOps MINGW64 crossplane/project/crossplane-and-argocd
$ kubectl apply -n argocd -f argocd/crossplane-bootstrap/crossplane-provider-aws.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/crossplane-provider-aws created

```


We run into the following error while syncing in Argo:

```shell
The Kubernetes API could not find aws.upbound.io/ProviderConfig for requested resource default/default. Make sure the "ProviderConfig" CRD is installed on the destination cluster.
```


### Install crossplane's AWS provider ProviderConfig with ArgoCD


```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -n argocd -f argocd/crossplane-bootstrap/crossplane-provider-aws-config.yaml 
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/crossplane-provider-aws-config created
```

After the config installed crossplane-provider-aws will be healthy

That was for testing one by one .

#doinng it all together

#Now we should be able to finally apply our Crossplane App of Apps in Argo:

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -n argocd -f argocd/crossplane-bootstrap.yaml 
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/crossplane-bootstrap created
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl get all -n crossplane-system
NAME                                                            READY   STATUS    RESTARTS        AGE
pod/crossplane-8676c674b6-727pz                                 1/1     Running   0               16m
pod/crossplane-rbac-manager-845ff686b4-4dnnn                    1/1     Running   0               16m
pod/provider-argocd-955c57a5ae2e-867569d869-9bpcx               1/1     Running   0               2m24s
pod/provider-aws-d244380f5072-7d59d49449-5v2h2                  1/1     Running   0               177m
pod/upbound-provider-aws-ec2-c339a6b52234-979c579b7-99wlq       1/1     Running   0               14m
pod/upbound-provider-aws-eks-4cfe1c8ddd10-568f868554-5bn7w      1/1     Running   0               14m
pod/upbound-provider-aws-iam-3943b3ae6617-6cd66d7c9f-x6dbb      1/1     Running   0               14m
pod/upbound-provider-aws-s3-8e38de3a77ee-6f9794584f-ht5zp       1/1     Running   0               14m
pod/upbound-provider-family-aws-9c2ce8bc65e7-5698b576d4-gbbrs   1/1     Running   4 (4h36m ago)   37h

NAME                                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/crossplane-webhooks           ClusterIP   10.109.10.183    <none>        9443/TCP   16m
service/provider-argocd               ClusterIP   10.104.84.67     <none>        9443/TCP   14m
service/provider-aws                  ClusterIP   10.97.191.34     <none>        9443/TCP   177m
service/upbound-provider-aws-ec2      ClusterIP   10.110.245.107   <none>        9443/TCP   14m
service/upbound-provider-aws-eks      ClusterIP   10.100.91.69     <none>        9443/TCP   14m
service/upbound-provider-aws-iam      ClusterIP   10.96.28.216     <none>        9443/TCP   14m
service/upbound-provider-aws-s3       ClusterIP   10.108.56.221    <none>        9443/TCP   14m
service/upbound-provider-family-aws   ClusterIP   10.108.240.131   <none>        9443/TCP   37h

NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/crossplane                                 1/1     1            1           16m
deployment.apps/crossplane-rbac-manager                    1/1     1            1           16m
deployment.apps/provider-argocd-955c57a5ae2e               1/1     1            1           2m24s
deployment.apps/provider-aws-d244380f5072                  1/1     1            1           177m
deployment.apps/upbound-provider-aws-ec2-c339a6b52234      1/1     1            1           14m
deployment.apps/upbound-provider-aws-eks-4cfe1c8ddd10      1/1     1            1           14m
deployment.apps/upbound-provider-aws-iam-3943b3ae6617      1/1     1            1           14m
deployment.apps/upbound-provider-aws-s3-8e38de3a77ee       1/1     1            1           14m
deployment.apps/upbound-provider-family-aws-9c2ce8bc65e7   1/1     1            1           37h

NAME                                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/crossplane-8676c674b6                                 1         1         1       16m
replicaset.apps/crossplane-rbac-manager-845ff686b4                    1         1         1       16m
replicaset.apps/provider-argocd-955c57a5ae2e-867569d869               1         1         1       2m24s
replicaset.apps/provider-aws-d244380f5072-7d59d49449                  1         1         1       177m
replicaset.apps/upbound-provider-aws-ec2-c339a6b52234-979c579b7       1         1         1       14m
replicaset.apps/upbound-provider-aws-eks-4cfe1c8ddd10-568f868554      1         1         1       14m
replicaset.apps/upbound-provider-aws-iam-3943b3ae6617-6cd66d7c9f      1         1         1       14m
replicaset.apps/upbound-provider-aws-s3-8e38de3a77ee-6f9794584f       1         1         1       14m
replicaset.apps/upbound-provider-family-aws-9c2ce8bc65e7-5698b576d4   1         1         1       37h

```

And like magic all our Crossplane components get deployed step by step in correct order:
Be sure to create both `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` configured as GitHub Repository Secrets:

## Doing it all steps
```yaml
name: crossplane-argocd

  # AWS
  AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
  AWS_DEFAULT_REGION: 'eu-central-1'

    runs-this-on: ubuntu-latest
    steps:
      - name: Install ArgoCD into kind
        run: |
          echo "--- Create argo namespace and install it"
          kubectl create namespace argocd

          echo " Install & configure ArgoCD via Kustomize - see https://stackoverflow.com/a/71692892/4964553"
          kubectl apply -k argocd/install
          
          echo "--- Wait for Argo to become ready"
          kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --namespace argocd --timeout=300s

      - name: Prepare crossplane AWS Secret
        run: |
          echo "--- Create aws-creds.conf file"
          echo "[default]
          aws_access_key_id = $AWS_ACCESS_KEY_ID
          aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
          " > aws-creds.conf
          
          echo "--- Create a namespace for crossplane"
          kubectl create namespace crossplane-system

          echo "--- Create AWS Provider secret"
          kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./aws-creds.conf

      - name: Use ArgoCD's AppOfApps pattern to deploy all Crossplane components
        run: |
          echo "--- Let Argo do it's magic installing all Crossplane components"
          kubectl apply -n argocd -f argocd/crossplane-bootstrap.yaml 

      - name: Check crossplane status
        run: |
          echo "--- Wait for crossplane to become ready (now prefaced with until as described in https://stackoverflow.com/questions/68226288/kubectl-wait-not-working-for-creation-of-resources)"
          until kubectl wait --for=condition=PodScheduled pod -l app=crossplane --namespace crossplane-system --timeout=120s > /dev/null 2>&1; do : ; done
          kubectl wait --for=condition=ready pod -l app=crossplane --namespace crossplane-system --timeout=120s

          echo "--- Wait until AWS Provider is up and running (now prefaced with until to prevent Error from server (NotFound): providers.pkg.crossplane.io 'provider-aws-s3' not found)"
          until kubectl get provider/provider-aws-s3 > /dev/null 2>&1; do : ; done
          kubectl wait --for=condition=healthy --timeout=180s provider/provider-aws-s3

          kubectl get all -n crossplane-system
```




## Finally provisioning Cloud resources with Crossplane and Argo

Let's create a simple S3 Bucket in AWS. [The docs tell us](https://marketplace.upbound.io/providers/upbound/provider-aws-s3/v0.47.1/resources/s3.aws.upbound.io/Bucket/v1beta1), which config we need. [`infrastructure/s3/simple-bucket.yaml`](infrastructure/s3/simple-bucket.yaml) features a super simply example:


Apply it with:

```shell

$ kubectl apply -f argocd/infrastructure/aws-s3.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/aws-s3 created

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl get -f argocd/infrastructure/aws-s3.yaml
NAME     SYNC STATUS   HEALTH STATUS
aws-s3   Synced        Healthy
```

If everything went fine, the Argo app should look `Healthy` like this.

And inside the AWS console, there should be a new S3 Bucket provisioned

## Deploy an EKS Cluster
### Multiple AWS Providers as ArgoCD Application
### Using the EKS Nested Composition as Configuration Package


Let's try to apply it to our cluster manually to test and use it:

To have Configuration connect to private docker image need to run below cmd / sh file
```shell
aws ecr get-login-password --region eu-central-1 | kubectl create secret docker-registry ecr-secret \
  --namespace crossplane-system \
  --docker-server=309272221538.dkr.ecr.eu-central-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region eu-central-1)
```

```shell

########
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ aws ecr get-login-password --region eu-central-1 | kubectl create secret docker-registry ecr-secret \
>   --namespace crossplane-system \
>   --docker-server=309272221538.dkr.ecr.eu-central-1.amazonaws.com \
>   --docker-username=AWS \
>   --docker-password=$(aws ecr get-login-password --region eu-central-1)
secret/ecr-secret created

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl describe secret/ecr-secret
Error from server (NotFound): secrets "ecr-secret" not found

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl describe secret/ecr-secret -n crossplane-system
Name:         ecr-secret
Namespace:    crossplane-system
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/dockerconfigjson

Data
====
.dockerconfigjson:  4284 bytes
```


#######
or 
#######
```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ bash  upbound/provider-aws/apis/ecrsecret.sh 309272221538 eu-central-1
secret/ecr-secret created
✅ ECR secret 'ecr-secret' created successfully in 'crossplane-system' namespace.
#######

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -f upbound/provider-aws/apis/crossplane-eks-cluster.yaml
configuration.pkg.crossplane.io/crossplane-eks-cluster created
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl describe secret/ecr-secret -n crossplane-system
Name:         ecr-secret
Namespace:    crossplane-system
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/dockerconfigjson

Data
====
.dockerconfigjson:  4284 bytes

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl describe -f upbound/provider-aws/apis/crossplane-eks-cluster.yaml
Name:         crossplane-eks-cluster
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  pkg.crossplane.io/v1
Kind:         Configuration
Metadata:
  Creation Timestamp:  2025-04-02T13:10:25Z
  Generation:          1
  Resource Version:    509760
  UID:                 6c75dfd4-ad87-471b-bc65-08c932647573
Spec:
  Ignore Crossplane Constraints:  false
  Package:                        309272221538.dkr.ecr.eu-central-1.amazonaws.com/crossplane-ecr:latest
  Package Pull Policy:            IfNotPresent
  Package Pull Secrets:
    Name:                      ecr-secret
  Revision Activation Policy:  Automatic
  Revision History Limit:      1
  Skip Dependency Resolution:  false
Status:
  Conditions:
    Last Transition Time:  2025-04-02T13:10:29Z
    Reason:                HealthyPackageRevision
    Status:                True
    Type:                  Healthy
    Last Transition Time:  2025-04-02T13:10:25Z
    Reason:                ActivePackageRevision
    Status:                True
    Type:                  Installed
  Current Identifier:      309272221538.dkr.ecr.eu-central-1.amazonaws.com/crossplane-ecr:latest
  Current Revision:        crossplane-eks-cluster-8e115c8c4087
Events:
  Type     Reason                  Age                From                                      Message
  ----     ------                  ----               ----                                      -------
  Warning  InstallPackageRevision  10s (x5 over 12s)  packages/configuration.pkg.crossplane.io  current package revision health is unknown
  Warning  InstallPackageRevision  9s (x2 over 9s)    packages/configuration.pkg.crossplane.io  current package revision is unhealthy
  Normal   InstallPackageRevision  8s (x2 over 9s)    packages/configuration.pkg.crossplane.io  Successfully installed package revision
```



### GitOpsify API installation: Use EKS Cluster Configuration in Argo Application

We should create an Argo Application for our EKS Configuration package to make Argo manage it's versions for us (which also makes the EKS Configuration viewable in Argo UI)!

Now we can apply this `crossplane-apis` Application to our ArgoCD:

after ecrsecret generation

```shell
bash  upbound/provider-aws/apis/ecrsecret.sh 309272221538 eu-central-1
```

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -f upbound/provider-aws/apis/crossplane-eks-cluster.yaml
configuration.pkg.crossplane.io/crossplane-eks-cluster created


kubectl apply -f argocd/crossplane-apis/crossplane-apis.yaml
```

That's pretty cool: Now we see all of our installed APIs as Argo Apps:



### Craft a Composite Resource Claim (XRC) to provision an EKS cluster

Now we use our installed APIs to create a Claim in [`infrastructure/eks/deploy-target-eks.yaml`]:

### Crossplane Composite Resource Claims (XRCs) as Argo Application

We should also create a Argo App for our EKS cluster Composite Resource Claim to see our infrastructure beeing deployed visually :)

Therefore we create the Application [`argocd/infrastructure/aws-eks.yaml`]:

Now **this** will deploy our EKS cluster using ArgoCD and our EKS Configuration Package based Nested EKS Composition:

Note: if only network required can try below steps else skip
```shell
$ kubectl apply -f argocd/infrastructure/aws-net.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/aws-networking created
```
setup whole eks package
```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -f argocd/infrastructure/aws-eks.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/aws-eks created
```



### Add the new EKS cluster as a new ArgoCD deploy target



Before using `argocd` CLI, be sure to have logged the CLI into the current argocd-server instance. Therefore have a port forward ready

```shell
$ kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8080:80

$ argocd login localhost:8080 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure
'admin:login' logged in successfully
Context 'localhost:8080' updated
```

https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_cluster_add/

```shell
argocd cluster add deploy-target-eks
```

This will add a few resources to the Target cluster like `ServiceAccount`, `ClusterRole` and `ClusterRoleBinding`:

```shell
$ argocd cluster add deploy-target-eks
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `deploy-target-eks` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0002] ServiceAccount "argocd-manager" already exists in namespace "kube-system" 
INFO[0002] ClusterRole "argocd-manager-role" updated    
INFO[0002] ClusterRoleBinding "argocd-manager-role-binding" updated 
Cluster 'https://736F91649BD7B7A70846AD9F8363EDA8.yl4.eu-central-1.eks.amazonaws.com' added
```

The new cluster becomes visible in the Argo web ui also:
