kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

kubectl proxy &

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

kubectl create sa dashboard -n default
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard
# kubectl delete clusterrolebinding dashboard-admin
# kubectl delete clusterrole cluster-admin
# kubectl delete sa dashboard

kubectl get secret $(kubectl get sa dashboard -o jsonpath="(.secrets[0].name)") -o jsonpath="{.data.token}" | base64 --decode

TOKENNAME=`kubectl -n devops get serviceaccount/devops-admin -o jsonpath='{.secrets[0].name}'`
