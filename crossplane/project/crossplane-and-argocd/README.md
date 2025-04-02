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

# Create Secret with Doppler Service Token
# be sure to have exported the env var locally, e.g. via
# export DOPPLER_SERVICE_TOKEN="dp.st.dev.dopplerservicetoken"
kubectl create secret generic doppler-token-auth-api --from-literal dopplerToken="$DOPPLER_SERVICE_TOKEN"

# Prepare Secret with ArgoCD API Token for Crossplane ArgoCD Provider (port forward can be run in subshell appending ' &' + Ctrl-C and beeing deleted after running create-argocd-api-token-secret.sh via 'fg 1%' + Ctrl-C)
kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8443:443
bash create-argocd-api-token-secret.sh




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

Now we should be able to finally apply our Crossplane App of Apps in Argo:

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

To be able to deploy a [nested Composition like this for EKS](https://github.com/jonashackt/crossplane-eks-cluster) we need to install multiple Crossplane Providers: `provider-aws-ec2`, `provider-aws-eks`, `provider-aws-iam` additionally to our already installed `provider-aws-s3`. Therefore we should enhance our concept on how to install a Provider with ArgoCD!

Since every Upbound provider family has one ProviderConfig to access the credentials, but multiple providers, it would make sense to enhance the Argo Application `argocd/crossplane-bootstrap/crossplane-provider-aws.yaml` to support multiple providers:

```yaml
# The ArgoCD Application for all Crossplane AWS providers incl. it's ProviderConfig
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: crossplane-provider-aws
  namespace: argocd
  labels:
    crossplane.jonashackt.io: crossplane
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: default
  source:
    repoURL: https://github.com/jonashackt/crossplane-argocd
    targetRevision: HEAD
    path: upbound/provider-aws/provider
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  # Using syncPolicy.automated here, otherwise the deployement of our Crossplane provider will fail with
  # 'Resource not found in cluster: pkg.crossplane.io/v1/Provider:provider-aws-s3'
  syncPolicy:
    automated:
      prune: true    
    retry:
      limit: 5
      backoff:
        duration: 5s 
        factor: 2 
        maxDuration: 1m
```

Thus this Application simply references the folder `upbound/provider-aws/provider`, where all the `Provider` manifests can be stored:

```shell
└── provider-aws
    ...
    ├── config
    │   └── provider-config-aws.yaml
    ...
    └── provider
        ├── provider-aws-ec2.yaml
        ├── provider-aws-eks.yaml
        ├── provider-aws-iam.yaml
        └── provider-aws-s3.yaml
```

Now in Argo, the Application shows all available Crossplane providers:

![](docs/multiple-crossplane-provider.png)


#### Provider Upgrade problems: 'Only one reference can have Controller set to true'

If new Provider versions get released, you can watch Argo trying to deploy the old version vs. Crossplane deploying the new one, which leads to a `degraded` status of the Providers:

![](docs/degraded-aws-providers.png)

The problem is this error: `Only one reference can have Controller set to true. Found "true" in references for Provider/provider-aws-ec2 and Provider/provider-aws-ec2`:

```shell
cannot apply package revision: cannot create object: ProviderRevision.pkg.crossplane.io "provider-aws-ec2-150095bdd614" is invalid: metadata.ownerReferences: Invalid value: []v1.OwnerReference{v1.OwnerReference{APIVersion:"pkg.crossplane.io/v1", Kind:"Provider", Name:"provider-aws-ec2", UID:"30bda236-6c12-412c-a647-b96368eff8b6", Controller:(*bool)(0xc02afeb38c), BlockOwnerDeletion:(*bool)(0xc02afeb38d)}, v1.OwnerReference{APIVersion:"pkg.crossplane.io/v1", Kind:"Provider", Name:"provider-aws-ec2", UID:"ee890f53-7590-4957-8f81-e92b931c4e8d", Controller:(*bool)(0xc02afeb38e), BlockOwnerDeletion:(*bool)(0xc02afeb38f)}}: Only one reference can have Controller set to true. Found "true" in references for Provider/provider-aws-ec2 and Provider/provider-aws-ec2
```

Therefore we should change some options regarding the Provider upgrades in our Provider configurations:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-aws-ec2
spec:
  package: xpkg.upbound.io/upbound/provider-aws-ec2:v1.1.1
  packagePullPolicy: IfNotPresent # Only download the package if it isn’t in the cache.
  revisionActivationPolicy: Automatic # Otherwise our Provider never gets activate & healthy
  revisionHistoryLimit: 1
```

As we're doing GitOpsified Crossplane with ArgoCD, we should configure the `packagePullPolicy` to `IfNotPresent` instead of `Always` (which means " Check for new packages every minute and download any matching package that isn’t in the cache", see https://docs.crossplane.io/master/concepts/packages/#configuration-package-pull-policy) - BUT leave the `revisionActivationPolicy` to `Automatic`! Since otherwise, the Provider will never get active and healty! See https://docs.crossplane.io/master/concepts/packages/#revision-activation-policy), but I didn't find it documented that way!


#### GitOpsified Provider Upgrade

See also https://stackoverflow.com/a/78230499/4964553

Now with `packagePullPolicy: IfNotPresent` & `revisionActivationPolicy: Automatic` to do a Provider version upgrade, we simply need to upgrade the `spec.package` version number:

```yaml
spec:
  package: xpkg.upbound.io/upbound/provider-aws-ec2:v1.2.1 # --> Upgraded to 1.2.1
  packagePullPolicy: IfNotPresent # Only download the package if it isn’t in the cache.
  revisionActivationPolicy: Automatic # Otherwise our Provider never gets activate & healthy
  revisionHistoryLimit: 1
```

We need to commit the change as always, but also be a bit patient here with Argo and Crossplane to initiate and do the update for us. Look at a `kubectl get providerrevisions`. Even after the update commited and registered by Argo, Crossplane will take it's time. First it looks like this:

```shell
k get providerrevisions
NAME                                       HEALTHY   REVISION   IMAGE                                                STATE      DEP-FOUND   DEP-INSTALLED   AGE
provider-aws-ec2-3d66ea2d7903              True      1          xpkg.upbound.io/upbound/provider-aws-ec2:v1.2.1      Active     1           1               5m31s
provider-aws-eks-5021e69b327c              True      2          xpkg.upbound.io/upbound/provider-aws-eks:v1.2.1      Inactive   1           1               4m11s
provider-aws-eks-fbb6768e46c0              True      3          xpkg.upbound.io/upbound/provider-aws-eks:v1.1.1      Active     1           1               30m
provider-aws-iam-9565c6312cd0              True      1          xpkg.upbound.io/upbound/provider-aws-iam:v1.1.1      Active     1           1               30m
provider-aws-s3-6ca829a5198b               True      1          xpkg.upbound.io/upbound/provider-aws-s3:v1.1.1       Active     1           1               30m
upbound-provider-family-aws-7cc64a779806   True      1          xpkg.upbound.io/upbound/provider-family-aws:v1.2.1   Active                                 30m
```

Now after a while and some events (look at them in `k9s` for example):

![](docs/upgrade-provider-k9s-events.png)

Some time later the new Provider version should be the `Active` one:

```shell
k get providerrevisions
NAME                                       HEALTHY   REVISION   IMAGE                                                STATE      DEP-FOUND   DEP-INSTALLED   AGE
provider-aws-ec2-3d66ea2d7903              True      1          xpkg.upbound.io/upbound/provider-aws-ec2:v1.2.1      Active     1           1               6m52s
provider-aws-eks-5021e69b327c              True      4          xpkg.upbound.io/upbound/provider-aws-eks:v1.2.1      Active     1           1               5m32s
provider-aws-eks-fbb6768e46c0              True      3          xpkg.upbound.io/upbound/provider-aws-eks:v1.1.1      Inactive   1           1               31m
provider-aws-iam-9565c6312cd0              True      1          xpkg.upbound.io/upbound/provider-aws-iam:v1.1.1      Active     1           1               31m
provider-aws-s3-6ca829a5198b               True      1          xpkg.upbound.io/upbound/provider-aws-s3:v1.1.1       Active     1           1               31m
upbound-provider-family-aws-7cc64a779806   True      1          xpkg.upbound.io/upbound/provider-family-aws:v1.2.1   Active                                 31m
```

And luckily without any errors like mentioned above!



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
kubectl apply -f upbound/provider-aws/apis/crossplane-eks-cluster.yaml

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
$ kubectl apply -f argocd/infrastructure/aws-eks.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/aws-eks created
```

That's pretty cool: Now we see all of our installed APIs as Argo Apps:



### Craft a Composite Resource Claim (XRC) to provision an EKS cluster

Now we use our installed APIs to create a Claim in [`infrastructure/eks/deploy-target-eks.yaml`](infrastructure/eks/deploy-target-eks.yaml):

### Crossplane Composite Resource Claims (XRCs) as Argo Application

We should also create a Argo App for our EKS cluster Composite Resource Claim to see our infrastructure beeing deployed visually :)

Therefore we create the Application [`argocd/infrastructure/aws-eks.yaml`](argocd/infrastructure/aws-eks.yaml):

Now **this** will deploy our EKS cluster using ArgoCD and our EKS Configuration Package based Nested EKS Composition https://github.com/jonashackt/crossplane-eks-cluster:

```shell

anik1@Anik-DevOps MINGW64 /crossplane/project/crossplane-and-argocd
$ kubectl apply -f argocd/infrastructure/aws-eks.yaml
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/aws-eks created
```



### Add the new EKS cluster as a new ArgoCD deploy target

![](docs/add-crossplane-created-cluster-to-argocd.png)


https://dev.to/thenjdevopsguy/registering-a-new-cluster-with-argocd-12mn

https://www.padok.fr/en/blog/argocd-eks

https://itnext.io/argocd-setup-external-clusters-by-name-d3d58a53acb0


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

![](docs/argocd-added-new-deploy-target-cluster.png)



### Add new EKS clusters declaratively to ArgoCD

Is there only the `argocd cluster add` command or could we achieve that using a manifest?

https://github.com/argoproj/argo-cd/issues/8107

Maybe the Crossplane ArgoCD Provider has the crucial Manifest for us? See https://github.com/crossplane-contrib/provider-argocd/issues/18 and https://marketplace.upbound.io/providers/crossplane-contrib/provider-argocd/v0.6.0/resources/cluster.argocd.crossplane.io/Cluster/v1alpha1


You might already wondered, what the Crossplane ArgoCD provider is about: https://marketplace.upbound.io/providers/crossplane-contrib/provider-argocd

Thats what the project README says https://github.com/crossplane-contrib/provider-argocd about it's purpose:

> Custom Resource Definitions (CRDs) that model Argo CD resources

With this we can create a [`Cluster`](https://marketplace.upbound.io/providers/crossplane-contrib/provider-argocd/v0.6.0/resources/cluster.argocd.crossplane.io/Cluster/v1alpha1) which is able to represent the EKS cluster we just created. This Cluster itself can be referenced again by an ArgoCD Application managing for example our Spring Boot application we finally want to deploy.


#### Install Crossplane ArgoCD Provider

> The whole process might become more straightforward in the future: https://github.com/crossplane-contrib/provider-argocd/issues/14#issuecomment-1879101376

So let's install the Crossplane ArgoCD provider, which is a community contribution project. Thus we create the `crossplane-contrib` folder containing a `provider-argocd` folder, where the new Provider should reside as `provider-argocd.yaml` in the `provider` dir:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-argocd
spec:
  package: xpkg.upbound.io/crossplane-contrib/provider-argocd:v0.6.0
  packagePullPolicy: IfNotPresent # Only download the package if it isn’t in the cache.
  revisionActivationPolicy: Automatic # Otherwise our Provider never gets activate & healthy
  revisionHistoryLimit: 1
```

As we want to manage the Provider also using Argo, we need to create a new Argo Application. It get's the same `argocd.argoproj.io/sync-wave: "4"` as the other providers in our setup:

```yaml
# The ArgoCD Application for all Crossplane Community contribution Providers needed in the setup
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: crossplane-provider-contrib
  namespace: argocd
  labels:
    crossplane.jonashackt.io: crossplane
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "4"
spec:
  project: default
  source:
    repoURL: https://github.com/jonashackt/crossplane-argocd
    targetRevision: app-deployment
    path: crossplane-contrib
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  # Using syncPolicy.automated here, otherwise the deployement of our Crossplane provider will fail with
  # 'Resource not found in cluster: pkg.crossplane.io/v1/Provider:provider-aws-s3'
  syncPolicy:
    automated:
      prune: true    
    retry:
      limit: 5
      backoff:
        duration: 5s 
        factor: 2 
        maxDuration: 1m
```

Apply it via the ususal bootstrap setup:

```shell
kubectl apply -f argocd/crossplane-eso-bootstrap.yaml
```

Argo should now list our new Provider:

![](docs/crossplane-contrib-argocd-provider-installed-by-argo.png)



#### Create ArgoCD user & RBAC role for Crossplane ArgoCD Provider

As stated in the docs https://github.com/crossplane-contrib/provider-argocd?tab=readme-ov-file#create-a-new-argo-cd-user we need to create an API token for the `ProviderConfig` of the Crossplane ArgoCD provider to use. To create the API token, we first need to create a new ArgoCD user.

Therefore we enhance [the ConfigMap `argocd-cm`](argocd/install/argocd-cm-patch.yaml) again:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  ...
  # add an additional local user with apiKey capabilities for provider-argocd
  # see https://github.com/crossplane-contrib/provider-argocd?tab=readme-ov-file#getting-started-and-documentation
  accounts.provider-argocd: apiKey      
```

As [the ArgoCD docs about user management](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#local-usersaccounts) state this is not enough:

> "each of those users will need additional RBAC rules set up, otherwise they will fall back to the default policy specified by policy.default field of the `argocd-rbac-cm` ConfigMap."

So we need to create another Kustomization patch for [the `argocd-rbac-cm` ConfigMap](argocd/install/argocd-rbac-cm-patch.yaml):

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  # For the provider-argocd user we need to add an additional rbac-rule
  # see https://github.com/crossplane-contrib/provider-argocd?tab=readme-ov-file#create-a-new-argo-cd-user
  policy.csv: "g, provider-argocd, role:admin"      
```

Don't forget to add this patch into the []`kustomization.yaml`](argocd/install/kustomization.yaml)!


#### Create API Token for Crossplane ArgoCD Provider

First we need to access the `argocd-server` Service somehow. In the simplest manner we create a port forward:

```shell
kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8443:443
```

We also need to have the ArgoCD password ready:

```shell
ARGOCD_ADMIN_SECRET=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
```

Now we create a temporary JWT token for the `provider-argocd` user we just created (we need to have [`jq`](https://jqlang.github.io/jq/) installed for this command to work):

```shell
# be sure to have jq installed via 'brew install jq' or 'pamac install jq' etc.

ARGOCD_ADMIN_TOKEN=$(curl -s -X POST -k -H "Content-Type: application/json" --data '{"username":"admin","password":"'$ARGOCD_ADMIN_SECRET'"}' https://localhost:8443/api/v1/session | jq -r .token)
```

Now we finally create an API token without expiration that can be used by `provider-argocd`:

```shell
ARGOCD_API_TOKEN=$(curl -s -X POST -k -H "Authorization: Bearer $ARGOCD_ADMIN_TOKEN" -H "Content-Type: application/json" https://localhost:8443/api/v1/account/provider-argocd/token | jq -r .token)
```

You can double check in the ArgoCD UI at `Settings/Accounts` if the Token got created:

![](docs/provider-argocd-api-token-created.png)



#### Create Secret containing the ARGOCD_API_TOKEN

https://github.com/crossplane-contrib/provider-argocd?tab=readme-ov-file#setup-crossplane-provider-argocd

The `ARGOCD_API_TOKEN` can be used to create a Kubernetes Secret for the Crossplane ArgoCD Provider:

```shell
kubectl create secret generic argocd-credentials -n crossplane-system --from-literal=authToken="$ARGOCD_API_TOKEN"
```

I also added all these steps to a script [`create-argocd-api-token-secret.sh`](create-argocd-api-token-secret.sh) so that we're able to run all the steps without much thinking:

```shell
#!/usr/bin/env bash
set -euo pipefail

echo "### This Script will prepare a K8s Secret with a ArgoCD API Token for Crossplane ArgoCD Provider (be sure to have a service/argocd-server 8443:443 running before)"

echo "--- Extract ArgoCD password"
ARGOCD_ADMIN_SECRET=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

echo "--- Create temporary JWT token for the provider-argocd user"
ARGOCD_ADMIN_TOKEN=$(curl -s -X POST -k -H "Content-Type: application/json" --data '{"username":"admin","password":"'$ARGOCD_ADMIN_SECRET'"}' https://localhost:8443/api/v1/session | jq -r .token)

echo "--- Create ArgoCD API Token"
ARGOCD_API_TOKEN=$(curl -s -X POST -k -H "Authorization: Bearer $ARGOCD_ADMIN_TOKEN" -H "Content-Type: application/json" https://localhost:8443/api/v1/account/provider-argocd/token | jq -r .token)

echo "--- Already create a namespace for crossplane for the Secret (if not already exist, see https://stackoverflow.com/a/65411733/4964553)"
kubectl create namespace crossplane-system --dry-run=client -o yaml | kubectl apply -f -

echo "--- Create Secret containing the ARGOCD_API_TOKEN for Crossplane ArgoCD Provider"
kubectl create secret generic argocd-credentials -n crossplane-system --from-literal=authToken="$ARGOCD_API_TOKEN"
```

Now all the steps to create the Secret for the Crossplane argocd-provider can be run via a simple:

```shell
kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8443:443
bash create-argocd-api-token-secret.sh
```

> The `kubectl port-forward` command can be run in subshell appending ` &` + `Ctrl-C` and beeing deleted after running create-argocd-api-token-secret.sh via `fg 1%` (where 1 is the subshell id, obtain via `jobs` command) + `Ctrl-C` (see https://stackoverflow.com/a/72983554/4964553 & https://www.baeldung.com/linux/foreground-background-process).

Our GitHub Actions workflow now also integrates the Secret creation:

```yaml
      - name: Prepare Secret with ArgoCD API Token for Crossplane ArgoCD Provider
        run: |
          echo "--- Access the ArgoCD server with a port-forward in the background, see https://stackoverflow.com/a/72983554/4964553"
          kubectl port-forward -n argocd --address='0.0.0.0' service/argocd-server 8443:443 &
          
          echo "--- Wait shortly to let the port forward come available"
          sleep 5

          bash create-argocd-api-token-secret.sh
```

As you can see we use a `sleep 5` timer here in order to let the `kubectl port-forward` to become ready. Otherwise will run into a `Error: Process completed with exit code 7.` like this::

```shell
--- Access the ArgoCD server with a port-forward in the background, see https://stackoverflow.com/a/72983554/4964553
### This Script will prepare a K8s Secret with a ArgoCD API Token for Crossplane ArgoCD Provider (be sure to have a service/argocd-server 8443:443 running before)
--- Extract ArgoCD password
--- Create temporary JWT token for the provider-argocd user
Forwarding from 0.0.0.0:8443 -> 8080
Error: Process completed with exit code 7.
```


#### Configure Crossplane ArgoCD Provider

Now finally we're able to tell our Crossplane ArgoCD Provider where it should obtain the ArgoCD API Token from. Let's create a ProviderConfig at [`crossplane-contrib/provider-argocd/config/provider-config-argocd.yaml`](crossplane-contrib/provider-argocd/config/provider-config-argocd.yaml):


```yaml
apiVersion: argocd.crossplane.io/v1alpha1
kind: ProviderConfig
metadata:
  name: argocd-provider
spec:
  credentials:
    secretRef:
      key: authToken
      name: argocd-credentials
      namespace: crossplane-system
    source: Secret
  insecure: true
  plainText: false
  serverAddr: argocd-server.argocd.svc:443
```

We should also create [a ArgoCD Application for the ProviderConfig](argocd/crossplane-eso-bootstrap/crossplane-provider-argocd-config.yaml):

```yaml
# The ArgoCD Application for the Crossplane ArgoCD providers ProviderConfig
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: crossplane-provider-argocd-config
  namespace: argocd
  labels:
    crossplane.jonashackt.io: crossplane
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  annotations:
    argocd.argoproj.io/sync-wave: "5"
spec:
  project: default
  source:
    repoURL: https://github.com/jonashackt/crossplane-argocd
    targetRevision: app-deployment
    path: crossplane-contrib/provider-argocd/config
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true    
    retry:
      limit: 5
      backoff:
        duration: 5s 
        factor: 2 
        maxDuration: 1m
```


#### Create a Cluster in ArgoCD referencing our Crossplane created EKS cluster

Now we're where we wanted to be: We can finally create a Cluster in ArgoCD referencing the Crossplane created EKS cluster. Therefore we make use of the [Crossplane ArgoCD Providers Cluster CRD](https://marketplace.upbound.io/providers/crossplane-contrib/provider-argocd/v0.6.0/resources/cluster.argocd.crossplane.io/Cluster/v1alpha1) in our [`infrastructure/eks/cluster.yaml`](infrastructure/eks/cluster.yaml):

```yaml
apiVersion: cluster.argocd.crossplane.io/v1alpha1
kind: Cluster
metadata:
  name: argo-reference-deploy-target-eks
  labels:
    purpose: dev
spec:
  forProvider:
    config:
      kubeconfigSecretRef:
        key: kubeconfig
        name: eks-cluster-kubeconfig # Secret containing our kubeconfig to access the Crossplane created EKS cluster
        namespace: default
    name: deploy-target-eks # name of the Cluster registered in ArgoCD
  providerConfigRef:
    name: argocd-provider
```

> **Be sure** to provide the `forProvider.name` **AFTER** the `forProvider.config`, otherwise the name of the Cluster *will we overwritten by the EKS server address from the kubeconfig*!

The `providerConfigRef.name.argocd-provider` references our `ProviderConfig`, which gives the Crossplane ArgoCD Provider the rights (via our API Token) to change the ArgoCD Server configuration (and thus add a new Cluster).

As the docs state https://marketplace.upbound.io/providers/crossplane-contrib/provider-argocd/v0.6.0/resources/cluster.argocd.crossplane.io/Cluster/v1alpha1

`kubeconfigSecretRef' is described at what we need: 

> KubeconfigSecretRef contains a reference to a Kubernetes secret entry that contains a raw kubeconfig in YAML or JSON. 

The Secret containing the exact EKS kubeconfig is named `eks-cluster-kubeconfig` by our EKS Configuration and resides in the `default` namespace.

Let's create the Cluster manually for now:

```shell
kubectl apply -f infrastructure/eks/cluster.yaml
```

If everything went correctly, a `kubectl get cluster` should state READY and SYNCED as `True`:

```shell
kubectl get cluster
NAME                               READY   SYNCED   AGE
argo-reference-deploy-target-eks   True    True     21s
```

And also in the ArgoCD UI you should find the newly registerd Cluster now at `Settings/Clusters`:

![](docs/cluster-in-argocd-referencing-crossplane-created-eks-cluster.png)


To also have the ArgoCD Cluster configuration available as Argo Application, it's enough to have the `cluster.yaml` be placed together with the `deploy-target-eks.yaml` in `infrastructure/eks` directory. The Argo Application argocd/infrastructure/aws-eks.yaml will pick it up:

![](docs/crossplane-argocd-provider-cluster-part-of-eks-argo-application.png)

It won't be available until the EKS cluster is fully deployed, thus producing some `CannotCreateExternalResource` events:

![](docs/argocd-provider-cluster-cannotcreateexternalresource-events.png)


### Deploy a app to the newly added target cluster

Now we finally finally have the cluster dynamically referencable via the Crossplane ArgoCD Provider created Cluster object with the name `deploy-target-eks`! Let's try to use that in an Application deployment.

In order to deploy our example app https://github.com/jonashackt/microservice-api-spring-boot

we need the corresponding Kubernetes deployment manifests, provided by https://github.com/jonashackt/microservice-api-spring-boot-config

Having both in place, we can craft a matching ArgoCD Application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: microservice-api-spring-boot
  namespace: argocd
  labels:
    crossplane.jonashackt.io: application
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/jonashackt/microservice-api-spring-boot-config
    targetRevision: HEAD
    path: deployment
  destination:
    namespace: default
    server: deploy-target-eks
  syncPolicy:
    automated:
      prune: true    
    retry:
      limit: 5
      backoff:
        duration: 5s 
        factor: 2 
        maxDuration: 1m
```

As you can see we use our Cluster name `deploy-target-eks` as `spec.destination.server`.

Now let's finally deploy our app via:

```shell
kubectl apply -f argocd/applications/microservice-api-spring-boot.yaml
```


But we get the following error in Argo: 

```shell
cluster 'deploy-target-eks' has not been configured
```

Looking [into the docs](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#applications) we get the point we're missing:

> `destination` reference to the target cluster and namespace. For the cluster one of server or name can be used, [...] Under the hood when the server is missing, it is calculated based on the name and used for any operations.

Thus we need to use `spec.destination.name` instead of `spec.destination.server`. This will then look into Argo's Cluster list and should find our `deploy-target-eks`.

Now the working manifest looks like this:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: microservice-api-spring-boot
  namespace: argocd
  labels:
    crossplane.jonashackt.io: application
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/jonashackt/microservice-api-spring-boot-config
    targetRevision: HEAD
    path: deployment
  destination:
    namespace: default
    name: deploy-target-eks
  syncPolicy:
    automated:
      prune: true    
    retry:
      limit: 5
      backoff:
        duration: 5s 
        factor: 2 
        maxDuration: 1m
```

```shell
kubectl apply -f argocd/applications/microservice-api-spring-boot.yaml
```


If everything went fine, our App should be deployed by ArgoCD:

![](docs/first-successful-application-deployment-to-target-eks-cluster.png)


Finally a full cycle is possible - from full bootstrap of ArgoCD & Crossplane Managed cluster to target EKS cluster creation in AWS via Crossplane to configuring that one in Argo and finally deploying an App dynamically referencing this Cluster! 





# Links

https://docs.crossplane.io/knowledge-base/integrations/argo-cd-crossplane/

https://blog.upbound.io/argo-crossplane-managing-application-stack

https://docs.upbound.io/concepts/mcp/control-plane-connector/

https://blog.upbound.io/2023-09-26-product-updates

https://morningspace.medium.com/using-crossplane-in-gitops-what-to-check-in-git-76c08a5ff0c4

Infrastructure-as-Apps https://codefresh.io/blog/infrastructure-as-apps-the-gitops-future-of-infra-as-code/

https://docs.upbound.io/spaces/git-integration/

https://codefresh.io/blog/using-gitops-infrastructure-applications-crossplane-argo-cd/

Configuration drift in Tf: Terraform horror stories about incomplete/invalid state https://www.youtube.com/watch?v=ix0Tw8uinWs





BADGES :

https://argo-cd.readthedocs.io/en/stable/user-guide/status-badge/


## App of Apps and ApplicationSets

https://codefresh.io/blog/argo-cd-application-dependencies/

https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern

https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/

https://github.com/argoproj/argo-cd/discussions/11892

https://github.com/christianh814/golist



## Crossplane producer of Secrets

https://docs.crossplane.io/knowledge-base/integrations/vault-as-secret-store/

> External Secret Stores are an alpha feature. They’re not recommended for production use. Crossplane disables External Secret Stores by default.

https://github.com/crossplane/crossplane/blob/master/design/design-doc-external-secret-stores.md

> storing sensitive information in external secret stores is a common practice. Since applications running on K8S need this information as well, it is also quite common to sync data from external secret stores to K8S. There are quite a few tools out there that are trying to resolve this exact same problem. **However, Crossplane, as a producer of infrastructure credentials, needs the opposite, which is storing sensitive information to external secret stores.**

--> So this feature is NOT for retrieving secrets FROM external secret providers, BUT for storing secrets IN external secret providers!

But the External Secrets Operator has also PushSecrets https://external-secrets.io/latest/api/pushsecret/ which seem to do the same
