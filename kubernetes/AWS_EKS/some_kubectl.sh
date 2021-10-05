# Get List of Ingress  (Make a note of Address field)
kubectl get ingress

# List Services
kubectl get svc

# Describe Ingress Controller
kubectl describe ingress ingress-usermgmt-restapp-service 

# Verify ALB Ingress Controller logs
kubectl logs -f $(kubectl get po -n kube-system | egrep -o 'alb-ingress-controller-[A-Za-z0-9-]+') -n kube-system

