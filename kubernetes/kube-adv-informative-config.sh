#static pods can identify names format  name-<nodehostname>
kubelet --pod-manifest-path=<the directory> # || Choose a directory, say /etc/kubernatics/manifests
#or         #Run the command> ps -aux | grep kubelet and identify the config file - --config=/var/lib/kubelet/config.yaml. Then checkin the config file for staticPodPath.
kubelet --config=kubeconfig.yaml  #|| vim kubeconfig.yaml >> staticPodPath: /etc/kubernatics/manifests

#deploy metrics-server(that stores data on memory) to monitor the running live PODs and Nodes.
#for minikube > minikube addons enable metrics-server  \/ 
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git && cd kubernetes-metrics-server/
kubectl apply -f .
-------------------------------
#Cluster part--for maintenance
kube-controller-manager --pod-eviction-timeout=5m0s
kubectl drain <node-no1>        #to safely evict all of your pods from a node before you perform maintenance on the node EG> kubectl drain node01 --ignore-daemonsets [-force use if standalone pod present]
kubectl uncordon <node-no1>     #after pod drained and once back online can be scheduled again > uncordon
kubectl cordon <node-no>       #Marking a node as unschedulable prevents the scheduler from placing new pods onto that Node, but does not affect existing Pods on the Node.
apt-get upgrade -y kubeadm=1.19.0-00        #kubeadm update eg. <version_no> = 1.19.0-00 
#or
apt install -y kubeadm=1.19.0-00            #force update to major version/not shown in planned version
kubeadm upgrade apply v1.19.0 -y            #for master node only
kubeadm upgrade node   #use this cmd For worker nodes  upgrades the local kubelet configuration || run this cmd from target node** only (for worker node applicable)
apt-get install -y kubelet=1.19.0-00        #kubelet upgrade on each node
kubeadm upgrade node config --kubelet-version v1.12.0 #kubeadm node config upgrade for kubelet v
-------------------------------
#kube package #KUBE UPDATE 
https://github.com/kubernetes/kubernetes/tags
kubernatics cluster upgrade: https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
cat /etc/*release*
#Determine which version to upgrade cluster: # find the latest version in the list  # it should look like 1.20.x-00, where x is the latest patch
apt update -y && apt-cache madison kubeadm                              #Debian  #||| run from master node* *(applicable for all)
yum list --showduplicates kubeadm --disableexcludes=kubernetes          #redhat  #||| run from master node* *(applicable for all)
#Call "kubeadm upgrade" : # # replace x in 1.20.x-00 with the latest patch version
apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.20.x-00 && \
apt-mark hold kubeadm                                           #debian ---------------- || run this cmd from target node** only (for worker node applicable)
yum install -y kubeadm-1.20.x-0 --disableexcludes=kubernetes    #redhat ---------------- || run this cmd from target node** only (for worker node applicable)
kubeadm version
#kube upgrade #kubeadm
kubeadm upgrade plan
kubeadm upgrade apply v1.12.0               #cluster upgrade
#sudo kubeadm upgrade node   #use this cmd For worker nodes  upgrades the local kubelet configuration || run this cmd from target node** only (for worker node applicable)
kubectl drain controlplane --ignore-daemonsets  #NODE=controlplane *for worker nodes if any standalone pod in place use flag --force 
#Upgrade kubelet and kubectl    # replace x in 1.20.x-00 with the latest patch version
apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.20.x-00 kubectl=1.20.x-00 && \
apt-mark hold kubelet kubectl                                                    #debian ----------------  || run this cmd from target node** only (for worker node applicable)
yum install -y kubelet-1.20.x-0 kubectl-1.20.x-0 --disableexcludes=kubernetes    #redhat ----------------  || run this cmd from target node** only (for worker node applicable)
sudo systemctl daemon-reload                                                     # || run this cmd from target node** only (for worker node applicable)
sudo systemctl restart kubelet                                                   # || run this cmd from target node** only (for worker node applicable)
kubectl uncordon controlplane               #||| run from master node* *(applicable for all)
kubectl get nodes                           #||| run from master node* *(applicable for all)
-------------------------------
 #ETCD Version
kubectl get pods -o wide -n kube-system |grep etcd
kubectl describe pod etcd-controlplane -n kube-system |grep Image:
ETCDCTL_API=3 etcdctl version
---
#ETCD setup
wget -q --https-only "https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz"
tar -xvf etcd-v3.3.9-linux-amd64.tar.gz
mv etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/
mkdir -p /etc/etcd /var/lib/etcd
cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
---
#etcd.service > HA
ExecStart=usr /local/ etcd
        --initial cluster controller 0=https://${CONTROLLER0_IP}:2380,controller 1=https://${CONTROLLER1_IP}:2380
---
#ETCDCTL CMD
export ETCDCTL_API=3
etcdctl put name <value>
etcdctl get name
etcdctl get / --prefix --keys-only		#O/p-Key valule=name
---
#Backup Solutions #ETCD
cp /etc/kubernetes/pki /opt/pki-bkp -r #backup certs
#backup ETCD  https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
     snapshot save /opt/snapshot-pre-boot.db
#snap status
ETCDCTL_API=3 etcdctl --write-out=table \
snapshot status /opt/snapshot-pre-boot.db
#restore ETCD
ETCDCTL_API=3 etcdctl snapshot restore /opt/snapshot-pre-boot.db --data-dir=/var/lib/etcd-from-backup #can restore on same dir or new dir like etcd-from-backup  
#incase used new dir for host path  #Modify>vim /etc/kubernetes/manifests/etcd.yaml file
 volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup       #Update host vol path of new target location
      type: DirectoryOrCreate
    name: etcd-data
---
#Or else
ls -ltR /var/lib/etcd-from-backup
ls -ltR /var/lib/etcd
rm -rf /var/lib/etcd/*   #remove old etcd dir
mv /var/lib/etcd-from-backup/* /var/lib/etcd/  #rename new etcd ,then wait for 2-3 min, thats all
---
#to see when the ETCD pod is restarted.
docker ps -a| grep etcd -w
# If the etcd pod is not getting Ready 1/1, then restart it
kubectl delete pod -n kube-system etcd-controlplane

-----------------------------------
#Security #Auth Mechanisms Basic #note:This is not recommended in a production environment. This is only for learning purposes.
#for kubeapiserver.service(ExecStart) or  etc/kubernetes/manifests/kube-apiserver.yaml (containers: /command:) add filds 
--basic auth file=21.1.Basic-AuthMechanism-Static-Password-File.csv       #for Static-Password-File
#verify auth of user
curl -v -k https://[master-node-ip]:6443/api/v1/pods -u "user1:password123" 
--token auth file=21.2.Basic-AuthMechanism-Static-Token-File.csv          #for Static-Token-File
#verify auth of user
curl -v -k https://[master-node-ip]:6443/api/v1/pods --header "Authorization: Bearer KpjCVbI7rCFAHYPkBzRb7gu1cUc4B"
-----------------   
#service account #<service-account-name>=SA1
kubectl get/describe sa -A
#get secret token from generated service account
kubectl -n kube-system get secret $TOKENNAME -o jsonpath='{.data.token}' | base64 -d   #$TOKENNAME /SECRET NAME CAN GET FROM> kubectl get sa SA1 -o yaml #decoded by base64 -d 
#store token and save ENV ver as $TOKEN_SA1 
TOKEN_SA1=$(kubectl -n kube-system get secret $TOKENNAME -o jsonpath='{.data.token}' | base64 -d)
echo $TOKEN_SA1
kubectl config set-credentials SA1 --token=$TOKEN_SA1
kubectl config view
#Set the user specified in the kubeconfig file for the current context to be the new service account user you created, by entering the following kubectl command:
kubectl config set-context --current --user=SA1 # --cluster=<cluster-name> in case if need to specify cluster
kubectl config set-context new-context --user=SA1 #for new context name=new-context
kubectl config use-context new-context          #switch to new context /your account
#if you subsequently want to remove access to the cluster from the service account
kubectl -n kube-system delete secret $TOKENNAME
---
#create service role
kubectl create serviceaccount <name>
kubectl get/describe role/rolebinding/clusterrole/clusterrolebinding <name> -A
kubectl create role pod-reader --verb=get --verb=list --verb=watch --resource=pods
kubectl create rolebinding bob-admin-binding --clusterrole=admin --user=bob --namespace=acme    #role binding
---
#Cluster role
kubectl create clusterrole pod-reader --verb=get,list,watch --resource=pods #--resource-name=readablepod #with resourceNames specified
kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=root    #cluster role binding
---
#kubernetes-the-hard-way setup:
https://github.com/kelseyhightower/kubernetes-the-hard-way#labs
https://github.com/mmumshad/kubernetes-the-hard-way#labs
---
kind create cluster --config 100.additional-cluster-config.yaml      #kind create cluster with custom config
---
#Deploy a Kubernetes Cluster using Kubeadm

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic       #for all nodes
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
#for HA control plane #skip for single control plane
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node
#at the end prompt will share config cmd that need to run and join node token need to keep handy and run to worker node to join or use 
#kubeadm token create --print-join-command   #update join token to worker node 
kubeadm init --pod-network-cidr <kube-ip-address> --apiserver-advertise-address=<ip-address>	 #masternodeip

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
#or
https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-installation
---
