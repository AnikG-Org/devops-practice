# App deploy manually


#before runnig the deployment run below scrit at app deployment namespace if 'ecr-secret' not created before

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project
$ bash appdeployment/ecrsecret.sh 309272221538 eu-central-1 default
secret/ecr-secret created
✅ ECR secret 'ecr-secret' created successfully in 'default' namespace.

anik1@Anik-DevOps MINGW64 /crossplane/project
$ kubectl get secret -n default
NAME         TYPE                             DATA   AGE
ecr-secret   kubernetes.io/dockerconfigjson   1      12s
```
# App deployment with argo cd

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project
$ kubectl apply -f crossplane-and-argocd/argocd/applications/
Warning: metadata.finalizers: "resources-finalizer.argocd.argoproj.io": prefer a domain-qualified finalizer name including a path (/) to avoid accidental conflicts with other finalizer writers
application.argoproj.io/awscommunityday created
```
Check the GUI now

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project
$ kubectl get po
NAME                               READY   STATUS    RESTARTS   AGE
awscommunityday-78ff576fbf-qlttf   1/1     Running   0          11m
anik1@Anik-DevOps MINGW64 /crossplane/project
$ kubectl get svc
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
awscommunityday   NodePort    10.104.150.187   <none>        80:30611/TCP   74m
kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP        9d

anik1@Anik-DevOps MINGW64 /crossplane/project
$ curl localhost:30611
<!doctype html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hello AWS community Kolkata</title>
    <link rel="stylesheet" href="https://unpkg.com/awsm.css/dist/awsm.min.css">
</head>

<body style="font-family: 'Poppins', sans-serif; font-weight: bold; font-size:1.3rem; color: white; background-color: #0F273E">

    <header>
        <h1>Welcome to AWS community,Day Kolkata 2025!!!!!!!</h1>
        <p>
            This is crossplane AWS Project
        </p>
    </header>
    <main>
        <form action="/howdy" method="post">
                Enter Name: <input type="text" name="name">  <br />

                <input type="submit" name= "form" value="Submit" />
            </form>

        <br>
    </main>
<p style="font-family: 'Poppins', sans-serif; font-weight: bold; line-height: 2rem; font-size:1.3rem; color: white; text-align: center; padding: 15px; background-color: #1B2731">Website : awscommunityday.com<br>We are : Anik Guha and soumyadeep bhattacharya
</p>
</body>
```
App is now ready
