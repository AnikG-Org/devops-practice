#!bin/bash
#kubectl cmds
kubectl version --short
kubectl cluster-info
cat ~./kube/config | less
kubeadm version
---
alias k=kubectl
complete -F __start_kubectl k
---
kubectl create namespace(ns) <name>
kubectl create/replace/delete -f <file.yml>     /  kubectl create -f <file.yml>--namespaces=<name> 
kubectl apply -f <file.yml>     /   kubectl apply -f <file.yml> --namespaces=<name> / kubectl apply -f /path/<config-files-folder>
kubectl apply -k ./ #k = kustomization file ./ all files in dir
k get all                      #kubectl=k
kubectl get componentstatuses
kubectl get/describe secrets/deamonsets
kubectl get pods/replicaset(rs)/rc/deployments(deploy)/namespace(ns)/svc(services)   /  kubectl get pods/rs/rc/deployments/svc -n <name> | wc -l #for word count
kubectl get <type> <name> -o yaml                # Get a kubes's tyoe YAML in details, eg, type=pods
kubectl get/describe services,nodes           # List/describe all services/nodes in the namespace
kubectl get pods --all-namespaces             # List all pods in all namespaces >> --all-namespaces or -A
kubectl get pods -o wide                      # List all pods in the current namespace, with more details
kubectl get pods -n kube-system               # kube components
kubectl get pods/all --selector env=dev,bu=IT    #list pods/all based on lebel
kubectl get events -w           #-w>>watch every 2 ec
kubectl get networkpolicy(netpol)
kubectl get PersistentVolume(pv)/PersistentVolumeClaim(pvc), storageclass(sc)
kubectl patch pv <your-pv-name> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'                     #change pv policy
kubectl get/describe <kind: value> #kind Ingress
kubectl config set-context --current --namespace=<name>         # permanently save the <name> namespace as default for all subsequent kubectl commands in that context.
kubectl autoscale deployment foo --min = 2 --max = 10
kubectl -n kube-system get ep kube-dns                  #ep = endpoints #coredns 

#example: pods=my-pod
kubectl logs -f pod <name> container <name>       # stream pod logs (stdout)
kubectl logs -l name=myLabel                  # dump pod logs, with label name=myLabel (stdout)
kubectl logs POD_NAME -c                      # use to list containers on a pod
kubectl logs pods --previous                  # dump pod logs (stdout) for a previous instantiation of a container
kubectl attach my-pod -i                            # Attach to Running Container
kubectl port-forward my-pod 5000:6000               # Listen on port 5000 on the local machine and forward to port 6000 on my-pod
kubectl exec my-pod -- cmd                          # Run command in existing pod (1 container case)
kubectl exec --stdin --tty my-pod -- /bin/sh        # Interactive shell access to a running pod (1 container case) 
kubectl exec my-pod -c my-container -- ls /         # Run command in existing pod (multi-container case)
kubectl top pod/node NAME --containers               # Show metrics for a given node / pod & its containers
kubectl top pod POD_NAME --sort-by=cpu              # Show metrics for a given pod and sort it by 'cpu' or 'memory'
watch "kubectl top node/pod "                           # Show metrics for a given node / pod on every 2 sec
kubectl edit/delete pods/replicaset/deployment <name>/ -f <name>.yaml
kubectl edit pod <pod name>         #A copy of the file with your changes is saved in a temporary location /tmp/name.yaml
kubectl scale --replicas=<number> replicaset/deployment <name>
#example=nginx/httpd
kubectl run nginx --image=nginx     /  kubectl run nginx --image=nginx -n mynamespace         # Run pod nginx in a specific namespace 
kubectl run nginx --image=nginx -l tier=web --dry-run=client -o yaml                          #-l as lebel, --labels="app=web,env=prod"
kubectl create namespace <name>
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --dry-run=client -o yaml --replicas=10 > httpd-deployment.yaml
kubectl expose deployment/pod <name> --port 80 --target-port 80 --name <name>-service --type=NodePort/ClusterIP --dry-run=client -o yaml
kubectl set image deployment nginx nginx=nginx:1.18

kubectl port-forward deployment/<name> <port-no>

#check access
kubectl auth can-i <cmd> #flags eg. --as <user_name> --namespace <ns_name> #eg.cmd=create pods

kubeadm list token
#taint node/pod     kubectl taint nodes <nodename> key=value:taint-effect       || taint-effect ><type>> NoSchedule | PreferNoSchedule | NoExecte
#example:    | NoSchedule: NoSchedule anything | PreferNoSchedule: Prefer NoSchedule but no gurenty | NoExecte: new pods will not schedule & existing 1 evicted if not tolerant taint
kubectl taint nodes node01 app=blue:NoSchedule
kubectl describe node <kubemaster> |grep Taint          #>O/P> Taints:             node-role.kubernetes.io/master:NoSchedul
kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-     #Remove the taint on master/controlplane >rolename-

#nodeselector
kubectl get nodes --show-labels
kubectl label nodes <name> <key>=<value>      #key=value> size=largeInstance lebel nodes

#rollout
kubectl apply -f deployment.yml --record=true
kubectl rollout status/history/pause/resume/undo deployment/<deployment-name>    #show status/history of deployment/undo/pause-resume deployment history>> kubectl rollout history deployment/<deployment-name> --revision <rev.no>
kubectl set image deployment/<deployment-name>  \                        #                                   specific prev v   undo>> kubectl rollout undo deployment/<deployment-name> --to-revision=<rev.no>
               <cont_name>=<image>:<version>                                  #image update
#configmaps
kubectl get/describe configmaps(cm)
kubectl create configmap \
        <config-name> --from-literal=<key>=<value> \
        <config-name> --from-literal=<key2>=<value2>            #Imperative||  
#OR from target Configfile>> 
         <config-name> --from-file=<path-to-file>
#secrets Imperative
kubectl explain pods --recursive | grep -A8 envForm

kubectl Imperative create secret generic \
        <secret-name> --from-literal=<key>=<value>
#or from target secret Configfile>> 
        <secret-name> --from-file=<path-to-file>    

echo –n ‘<value>’ | base64 || OR ||  echo ‘<value>’ | base64            #encode secrets from plain text to hashvalue
echo –n ‘mysql’ | base64                #eg. value= mysql
  o/p>> abcxyz=

echo -n ‘<hashvalue>’ | base64 -d  || OR ||  echo ‘<value>’ | base64 -d   #decode secrets from hashvalue to plain text
echo -n ‘abcxyz=’ | base64 --decode    #eg. hash_value= abcxyz=
  o/p>> mysql
---
kubectl get/describe roles/rolebindings
kubectl get clusterroles+/clusterrolebindings --no-headers
kubectl get clusterroles --no-headers -o json | jq '.items | length'
----
kubectl api-resources --namespaced=true         #list namespace resources
kubectl api-resources --namespaced=FALSE        #list non namespace resources
---
#kube-controller-manager leader-elect values for HA
kube-controller-manager --leader-elect true [other options]
                        --leader-elect-lease-duration 15s
                        --leader-elect-renew-deadline 10s
                        --leader-elect-retry-period 2s
---
#controlplane checks
service <controlplane_service> status                   #<controlplane_service> = E.g=  kube-controller-manager / kube-apiserver / kube-scheduler / kubelet/ kube-proxy
kubectl logs <controlplane_service> -n kube-system
sudo journalctl -u <controlplane_service>
kubectl cluster-info
#node checks
systemctl status kubelet -l
journalctl -u kubelet -f
----
#Json query
kubectl get nodes -o json
kubectl get nodes -o=jsonpath='{query}' #for multiple query > '{query1} {"\n"} {query2}' | '{query1} {"\t"} {query2}'
kubectl get nodes -o=jsonpath='{range.items[*]}{.metadata.name} {"\t"} {.status.capacity.cpu}{"\n"} {end}'                   #query: {.items[*].metadata.name} and {.items[*].status.capacity.cpu}
kubectl get nodes -o=custom-columns=<custom_name1>:<query>,<custom_name2>:<query>             #eg.<custom_name1>=NODE, <custom_name2>=CPU
kubectl get nodes --short-by= query #eg. query= .status.capacity.cpu
---
