ip link    /ifconfig -a / cat /etc/network/interfaces         #identify the interface
ip link show <interface>
kubectl get nodes -o wide  / ifconfig <interface>   #find IP
ip addr add 192.168.1.10/24 dev eth0
route
ip route / ip r
ip route show default
ip route add 192.168.1.0/24 via 192.168.2.1
ip addr
ip addr show <eth_name>
cat /proc/sys/net/ipv4/ip_forward
> 1
arp <nodename>  / ssh <nodename> ifconfig <interface>   #to find MAC address assigned to nodename
netstat -plnt
netstat -anp | grep <app name> | grep LISTEN
ls /etc/cni/net.d/         #find cni plugin used in cluster

------
# ❑ Networking Model   #BRIDGE IP: 192.168.15.1/24 type: v-net-0   #namespace red[peer: veth-red-br], blue[Peer: veth-blue-br] #NETWORK CIDR: 192.168.15.0/24
ip link add v-net-0 type bridge     #creating bridge network on a node
ip link set dev v-net-0 up          #bring that up
ip addr add 192.168.15.1/24 dev v-net-0     #set IP addr on that network
#cat  net-scrptch.sh    >
-----
ADD)
# Create veth pair
ip link add veth-red type veth peer name veth-<namespace>-br   
#attach veth pair
ip link set veth-<namespace> netns <namespace>                  #attach veth pair to namespace
ip link set veth-<namespace>-br master v-net-0          #attach veth pair to bridge
#assgn IP addr
ip -n <namespace> addr add 192.168.15.2 dev veth-<namespace>                   #assgn IP addr to <n <namespace>
ip -n <namespace> route add <other_node-namespaceIP/bridge-CIDR> via <other_nodeIP>        #assgin other node bridge/namespace CIDR via other nodeIP
# Bring Up Interface
ip -n <namespace> link set veth-<namespace> up
DEL)
# Delete veth pair
ip link del veth-red type veth peer name veth-<namespace>-br 
-----
ip netns exec blue ip route add <namespaceIP> via <other_nodeIP>                  #ad route to namespace to other node connection
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE
---
#> In this example we are using Weave-Net CNI plugin- addon:
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl get pod -n kube-system -o wide |grep weave
#flannel  #https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
#Calico 
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml      # Apply the manifest using the following command.
#Kube-proxy cmds
kubeproxy proxy mode [ userspace | iptables | ipvs | firewalld]
kube-api-server --service-cluster-ip-range ipNet
ps aux | grep kube-api-server
iptables –L –t net | grep <service>          #e.g: service= db-service
cat /var/log/kube-proxy.log         #check kubeproxy logs
kubectl logs <weave-pod-name> weave -n kube-system      #the range of IP addresses configured for PODs #userd weave deamons
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range       #the IP Range configured for the services within the cluster
kubectl -n kube-system describe deployments.apps coredns | grep -A2 Args | grep Corefile       #CoreDNS conf file
