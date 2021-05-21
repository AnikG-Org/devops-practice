kubeadm certs check-expiration
journalctl -u etcd.service -l
kubectl logs etcd-master
cat /etc/kubernetes/manifests/kube-apiserver.yaml   #find cert config
cat /etc/kubernetes/manifests/etcd.yaml             #find cert config
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout     #decode certificate cert Path=/etc/kubernetes/pki/apiserver.crt
openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout 
openssl x509 -in /etc/kubernetes/pki/ca.crt -text -noout 
openssl x509 -in /<path>/ca.crt -text	#TO CHECK CERT validity


#	Certificate (Public Key)				Private Key             #key formats            https://kubernetes.io/docs/concepts/cluster-administration/certificates/#openssl
#	-------------------------		-------------------------
#		*.crt *.pem							*.key *-key.pem
#kubernatics CA server Certs: -         #tool use: OPENSSL
openssl genrsa -out ca.key 2048                                         #Generate Keys O/P: ca.key
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr		#Certificate Signing Request for KUBERNETES-CA   O/P: ca.csr
openssl x509 -req -days 9999 -in ca.csr -signkey ca.key -out ca.crt		        #Sign Certificates O/P: ca.crt

#kubernatics Client side Certs: - #admin 
openssl genrsa -out admin.key 2048
openssl req -new -key admin.key -subj "/CN=kube-admin" -out admin.csr     #user_name=kube-admin 
#OR
openssl req -new -key admin.key -subj "/CN=kube-admin/OU=system:masters" -out admin.csr     #user_name=kube-admin with OU group: masters >admin access
openssl x509 -req -in admin.csr –CA ca.crt -CAkey ca.key -out admin.crt -days 9999             #signing [admin.crt]cert via server side ca crt & key file
#for kube system clients like: KUBE-SCHEDULER,KUBE-CONTOLLER-MANAGER,KUBE-PROXY etc.. use system as prefix like>>'system:kube-scheduler' while generating certs
openssl genrsa -out kube-scheduler.key 2048
openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler" -out kube-scheduler.csr
openssl x509 -req -in kube-scheduler.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-scheduler.crt -days 9999
---
openssl genrsa -out kube-controller-manager.key 2048
openssl req -new -key kube-controller-manager.key -subj "/CN=system:kube-controller-manager" -out kube-controller-manager.csr
openssl x509 -req -in kube-controller-manager.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-controller-manager.crt -days 1000
---
openssl genrsa -out kube-proxy.key 2048
openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy" -out kube-proxy.csr
openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-proxy.crt -days 1000
---

#kubernatics Server side Certs: - #ETCD-SERVER side cert # use openssl-etcd.cnf incase calling etcd server by alt_names
cat > openssl-etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 192.168.5.11
IP.2 = 192.168.5.12
IP.3 = 127.0.0.1
EOF
---
openssl genrsa -out etcd-server.key 2048
openssl req -new -key etcd-server.key -subj "/CN=etcd-server" -out etcd-server.csr -config openssl-etcd.cnf
openssl x509 -req -in etcd-server.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out etcd-server.crt -extensions v3_req -extfile openssl-etcd.cnf -days 1000
--- #etcd peer
openssl genrsa -out etcdpeer1.key 2048
openssl req -new -key etcdpeer1.key -subj "/CN=etcd-peer" -out etcdpeer1.csr
openssl x509 -req -in etcdpeer1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcdpeer1.crt -days 1000
#>cat etcd.yaml         #ADD PEER CERT'S TO ETCD CONF 

- etcd
- --advertise-client-urls=https://127.0.0.1:2379
- --key-file=/path-to-certs/etcdserver.key			        #
- --cert-file=/path-to-certs/etcdserver.crt			        #
- --client-cert-auth=true
- --data-dir=/var/lib/etcd
- --initial-advertise-peer-urls=https://127.0.0.1:2380
- --initial-cluster=master=https://127.0.0.1:2380
- --listen-client-urls=https://127.0.0.1:2379
- --listen-peer-urls=https://127.0.0.1:2380
- --name=master
- --peer-cert-file=/path-to-certs/etcdpeer1.crt				#
- --peer-client-cert-auth=true								#
- --peer-key-file=/etc/kubernetes/pki/etcd/peer.key			#
- --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt	#
- --snapshot-count=10000
- --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt			#

---
#kubernatics Server side Certs: - #KUBE-API SERVER
cat > openssl.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 192.168.5.11
IP.3 = 192.168.5.12
IP.4 = 192.168.5.30
IP.5 = 127.0.0.1
EOF
---
openssl genrsa -out kube-apiserver.key 2048
openssl req -new -key kube-apiserver.key -subj "/CN=kube-apiserver" -out kube-apiserver.csr -config openssl.cnf
openssl x509 -req -in kube-apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-apiserver.crt -extensions v3_req -extfile openssl.cnf -days 1000
---
# certcreate format         #for server side cer use subs like= -subj "/CN=service-accounts" , Client side: -subj "/CN=system:kube-scheduler", user with grp = -subj "/CN=kube-admin/OU=system:masters"
openssl genrsa -out <certname>.key 2048
openssl req -new -key <certname>.key -subj "/CN=CN-NMAE" -out <certname>.csr
openssl x509 -req -in <certname>.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out <certname>.crt -days 9999
---
#Certificate API managed by controller-manager #> mandate fiend for signing using CA certificate
cat /etc/kubernetes/manifests/kube-controller-manager.yaml
>	- --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
	- --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
	
---			#create user and approve cert from CERTIFICATE API
openssl genrsa -out user1.key 2048                                  	#create user    O/p> user1.key
openssl req -new -key user1.key -subj "/CN=user1" -out user1.csr		#send request to sign the key o/p> user1.csr
#admin takes the cert and encode the cert value
---
# created user1.csr
#  -----BEGIN CERTIFICATE REQUEST-----
#  MIICWDCCAUACAQAwEzERMA8GA1UEAwwIbmV3LXVzZXIwggEiMA0GCSqGSIb3DQEB
#  AQUAA4IBDwAwggEKAoIBAQDO0WJW+DXsAJSIrjpNo5vRIBplnzg+6xc9+UVwkKi0
#  LfC27t+1eEnON5Muq99NevmMEOnrDUO/thyVqP2w2XNIDRXjYyF40FbmD+5zWyCK
#  9w0BAQsFAAOCAQEAS9iS6C1uxTuf5BBYSU7QFQHUzalNxAdYsaORRQNwHZwHqGi4
#  hOK4a2zyNyi44OOijyaD6tUW8DSxkr8BLK8Kg3srREtJql5rLZy9LRVrsJghD4gY
#  P9NL+aDRSxROVSqBaB2nWeYpM5cJ5TF53lesNSNMLQ2++RMnjDQJ7juPEic8/dhk
#  Wr2EUM6UawzykrdHImwTv2mlMY0R+DNtV1Yie+0H9/YElt+FSGjh5L5YUvI1Dqiy
#  4l3E/y3qL71WfAcuH3OsVpUUnQISMdQs0qWCsbE56CC5DhPGZIpUbnKUpAwka+8E
#  vwQ07jG+hpknxmuFAeXxgUwodALaJ7ju/TDIcw==
#  -----END CERTIFICATE REQUEST-----
---
#encode this cert>> cat user1.csr | base64          #Update value to yaml file

#  LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0
#  tLS0KTUlJQ1dEQ0NBVUFDQVFBd0V6RVJNQThHQTFVRU
#  F3d0libVYzTFhWelpYSXdnZ0VpTUEwR0NTcUdTSWIzR
#  FFFQgpBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRRE8wV0pX
#  K0RYc0FKU0lyanBObzV2UklCcGxuemcrNnhjOStVVnd
#  rS2kwCkxmQzI3dCsxZUVuT041TXVxOTlOZXZtTUVPbnJ
---
kubectl apply -f 23.user1-cert-sign-req(csr).yaml
kubectl get csr								#csr status
kubectl certificate approve user1			#approve cert user1
kubectl certificate deny user1              #to deny request
kubectl delete csr user1                    #to delete user
kubectl get csr user1 -o yaml				#get user cert in details
kubectl config view -o jsonpath='{.users[*].name}'	# get a list of users
kubectl config unset users.foo                       # delete user foo
kubectl config view -o jsonpath='{.users[?(@.name == "e2e")].user.password}'	# get the password for the e2e user
---
echo “LS0…Qo=” | base64 --decode			#decode encoded cert value
---
kubectl config view
kubectl config --kubeconfig=24.kubeConfig.yaml use-context admin-local@local
kubectl config set-context --current --namespace=<name>  
---
# to check the specific task permission level
kubectl auth can-i <request> <task_object>      #eg: kubectl auth can-i create deployments || kubectl auth can-i delete nodes
kubectl auth can-i <request> <task_object> --as <username>  #from other user prospective without user login #eg: kubectl auth can-i create pods --as dev-user --namespace test
kubectl describe pod kube-apiserver-controlplane -n kube-system #to check auth mode