# App deploy manually


#before runnig the deployment run below scrit at app deployment namespace if 'ecr-secret' not created before

```shell
anik1@Anik-DevOps MINGW64 /e/Dev/sand-fold/crossplane/project
$ bash appdeployment/ecrsecret.sh 309272221538 eu-central-1 default
secret/ecr-secret created
✅ ECR secret 'ecr-secret' created successfully in 'default' namespace.

anik1@Anik-DevOps MINGW64 /e/Dev/sand-fold/crossplane/project
$ kubectl get secret -n default
NAME         TYPE                             DATA   AGE
ecr-secret   kubernetes.io/dockerconfigjson   1      12s
```


