# Apbuild manually

```shell
anik1@Anik-DevOps MINGW64 /crossplane/project/Appbuild
$ aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 309272221538.dkr.ecr.eu-central-1.amazonaws.com
Login Succeeded

anik1@Anik-DevOps MINGW64 /crossplane/project/Appbuild
$ docker build -t crossplane-app .
[+] Building 189.3s (4/6)                                                                                                                                                                  docker:desktop-linux 
 => [internal] load build definition from Dockerfile                                                                                                                                                       0.2s 
 => => transferring dockerfile: 139B                                                                                                                                                                       0.1s 
 => [internal] load metadata for docker.io/tiangolo/uwsgi-nginx-flask:latest                                                                                                                              22.7s 
[+] Building 189.5s (4/6)                                                                                                                                                                  docker:desktop-linux 
 => => transferring context: 2B                                                                                                                                                                            0.0s 
 => [internal] load build context                                                                                                                                                                          0.1s 
 => => transferring context: 3.01kB                                                                                                                                                                        0.1s 
[+] Building 684.3s (7/7) FINISHED                                                                                                                                                         docker:desktop-linux 
 => [internal] load build definition from Dockerfile                                                                                                                                                       0.2s 
 => => transferring dockerfile: 139B                                                                                                                                                                       0.1s 
 => [internal] load metadata for docker.io/tiangolo/uwsgi-nginx-flask:latest                                                                                                                              22.7s 
 => [internal] load .dockerignore                                                                                                                                                                          0.0s 
 => => transferring context: 2B                                                                                                                                                                            0.0s 
 => [internal] load build context                                                                                                                                                                          0.1s 
 => => transferring context: 3.01kB                                                                                                                                                                        0.1s 
 => [1/2] FROM docker.io/tiangolo/uwsgi-nginx-flask:latest@sha256:864a5c25d5cff5da8cf8334c0d0af12c509f2039464582cbccab505847319215                                                                       659.9s 
 => => resolve docker.io/tiangolo/uwsgi-nginx-flask:latest@sha256:864a5c25d5cff5da8cf8334c0d0af12c509f2039464582cbccab505847319215                                                                         0.0s 
 => => sha256:57b476bbd1133140c1cad2010249e946b94b905642bc172ca2c2ea9370d0b152 5.98kB / 5.98kB                                                                                                             0.0s 
 => => sha256:6df16681c019573e3211da3a69493c28abc41e22e0cfaaf006fa4e8a20965295 15.56MB / 15.56MB                                                                                                         343.6s 
 => => sha256:20d363a1dd2d1714709c84ac8d050f51e921efc51885c202b336cc24f61e3186 54.75MB / 54.75MB                                                                                                         601.3s
 => => sha256:864a5c25d5cff5da8cf8334c0d0af12c509f2039464582cbccab505847319215 1.61kB / 1.61kB                                                                                                             0.0s
 => => sha256:de97e8062e06250e3c3cef0d40cfe62111bb4b74bcf6221e25a06452dacffcf6 53.74MB / 53.74MB                                                                                                         589.5s
 => => sha256:5b20e9d4b8b1e6abaab675e69eb4eb07aeb3e34c421bfc75685eb47a4ea4a500 14.16kB / 14.16kB                                                                                                           0.0s
 => => sha256:e7ff86202e7c3afa44ea1524a6f7520668801c0913bb650d2d105f267afcdc35 197.07MB / 197.07MB                                                                                                       615.2s
 => => sha256:be00056a714c9657ec70209606fc01db55b56f88505a9ed615420737573f0384 6.05MB / 6.05MB                                                                                                           593.6s
 => => extracting sha256:de97e8062e06250e3c3cef0d40cfe62111bb4b74bcf6221e25a06452dacffcf6                                                                                                                 15.2s
 => => sha256:19cc4c0abf462e9fbc401e827a38f7e6436357856116f89888ad70c12e83a621 26.14MB / 26.14MB                                                                                                         606.3s
 => => sha256:378d7fce4dff26ca91c668092be2200c7c83ac2a368a6f3ced66539408a17c9e 249B / 249B                                                                                                               602.3s
 => => sha256:a2ab3f6a322eabb1833096877b99ec74203aaf5d8318ea8d8547286f43ea46b8 1.32kB / 1.32kB                                                                                                           602.9s
 => => sha256:e643115b2520640281af6502b1909b1b97e9a94f3e3acc10e6f9a42e2ffd39d7 4.30MB / 4.30MB                                                                                                           604.9s
 => => sha256:16532bf1b5beac4efbb6aed52ad84a7e6efeda00a6d28be1e237e243cbd6eb8e 159B / 159B                                                                                                               605.8s
 => => extracting sha256:6df16681c019573e3211da3a69493c28abc41e22e0cfaaf006fa4e8a20965295                                                                                                                  2.2s
 => => sha256:d4c2e7384fa8f6eabec2f7588d35fd7d21d891ef162599bd15c0ec33b73263ec 1.95MB / 1.95MB                                                                                                           606.7s
 => => sha256:793ac3d957e494bcf299919a144136dfe066d35e0d7a5eef47258deafe60b51b 175B / 175B                                                                                                               607.2s
 => => sha256:45cd9438d28c2401733cf35c1cb90be33a4d871dd56d31d8fd1735b9c43c7920 379B / 379B                                                                                                               607.1s
 => => sha256:9479def603a35d240f4f8473cf891aecf1817dba9ab39fd99744ff5ee5b1b19f 1.34MB / 1.34MB                                                                                                           608.9s
 => => sha256:c5705e0015bc4ee8eb458e2abef077e638cd203b325cb153cb759c6d40cd78b9 468B / 468B                                                                                                               608.2s
 => => extracting sha256:20d363a1dd2d1714709c84ac8d050f51e921efc51885c202b336cc24f61e3186                                                                                                                 12.3s
 => => sha256:add37741f4c2741925bc6011acf88261b62900646dc1342df315890f612c8c0c 471B / 471B                                                                                                               608.7s
 => => sha256:588106d94f3b10e5df8dc81158a870a8e1dad7277c215170dd737471cb697776 464B / 464B                                                                                                               609.7s
 => => sha256:f74e00e12921aaa8523363a6b5a659f6f87ba13531b573dbaf45220b2ab4b8b3 323B / 323B                                                                                                               609.3s
 => => sha256:a2aa857eb7cebab395eb48a127de6bc1f4e20da0d4866144154b01f51b77e748 322B / 322B                                                                                                               609.7s
 => => sha256:5c512997c0157e321d7c104e529ca16368f515414f30420421ad0135bee60af5 1.03kB / 1.03kB                                                                                                           610.1s
 => => sha256:00af86c53b37119214e738e8e8c1a206bda99ea1658ccd4a5a2da4c9fee0d65e 1.03kB / 1.03kB                                                                                                           610.1s
 => => sha256:8947a82ab129f041bf3454af1d99685972ee6032fe79e4310150c89ecab8d095 564B / 564B                                                                                                               610.4s
 => => sha256:4f4fb700ef54461cfa02571ae0db9a0dc1e0cdb5577484a6d75e68dc38e8acc1 32B / 32B                                                                                                                 610.4s
 => => sha256:07c2d39aacb90c764420be02ee735fac162785301fc27993bc229ec71c119986 1.55MB / 1.55MB                                                                                                           611.3s
 => => sha256:fff9c052994de414b1a6d4788580900e2d53131fe8bd691ed79eb43f69ace96a 158B / 158B                                                                                                               611.0s
 => => sha256:b33db0b7e8d4ba0867ddd715e5332055576af622cd750f7c72756d3df0496a61 580B / 580B                                                                                                               611.3s
 => => sha256:d075b4a20d6008e82f23cc72e78ab43d9009d92bbc99883026ead039ff03cb5c 1.05kB / 1.05kB                                                                                                           611.6s
 => => sha256:c7bafd9d907fce14064c8604352df6543bc0f8baeac507e03fa32a13d6cb67ac 639B / 639B                                                                                                               611.7s
 => => sha256:32051821f443f3dfca545ff40b2d597e9c07efa80d83cd68030beceea7976a8d 640B / 640B                                                                                                               612.0s
 => => extracting sha256:e7ff86202e7c3afa44ea1524a6f7520668801c0913bb650d2d105f267afcdc35                                                                                                                 27.8s
 => => extracting sha256:be00056a714c9657ec70209606fc01db55b56f88505a9ed615420737573f0384                                                                                                                  1.2s
 => => extracting sha256:19cc4c0abf462e9fbc401e827a38f7e6436357856116f89888ad70c12e83a621                                                                                                                  3.2s
 => => extracting sha256:378d7fce4dff26ca91c668092be2200c7c83ac2a368a6f3ced66539408a17c9e                                                                                                                  0.0s
 => => extracting sha256:a2ab3f6a322eabb1833096877b99ec74203aaf5d8318ea8d8547286f43ea46b8                                                                                                                  0.0s
 => => extracting sha256:e643115b2520640281af6502b1909b1b97e9a94f3e3acc10e6f9a42e2ffd39d7                                                                                                                  0.5s
 => => extracting sha256:16532bf1b5beac4efbb6aed52ad84a7e6efeda00a6d28be1e237e243cbd6eb8e                                                                                                                  0.0s
 => => extracting sha256:d4c2e7384fa8f6eabec2f7588d35fd7d21d891ef162599bd15c0ec33b73263ec                                                                                                                  0.1s
 => => extracting sha256:793ac3d957e494bcf299919a144136dfe066d35e0d7a5eef47258deafe60b51b                                                                                                                  0.0s
 => => extracting sha256:45cd9438d28c2401733cf35c1cb90be33a4d871dd56d31d8fd1735b9c43c7920                                                                                                                  0.0s
 => => extracting sha256:9479def603a35d240f4f8473cf891aecf1817dba9ab39fd99744ff5ee5b1b19f                                                                                                                  0.5s 
 => => extracting sha256:c5705e0015bc4ee8eb458e2abef077e638cd203b325cb153cb759c6d40cd78b9                                                                                                                  0.0s 
 => => extracting sha256:add37741f4c2741925bc6011acf88261b62900646dc1342df315890f612c8c0c                                                                                                                  0.0s 
 => => extracting sha256:588106d94f3b10e5df8dc81158a870a8e1dad7277c215170dd737471cb697776                                                                                                                  0.0s 
 => => extracting sha256:f74e00e12921aaa8523363a6b5a659f6f87ba13531b573dbaf45220b2ab4b8b3                                                                                                                  0.0s 
 => => extracting sha256:a2aa857eb7cebab395eb48a127de6bc1f4e20da0d4866144154b01f51b77e748                                                                                                                  0.0s 
 => => extracting sha256:00af86c53b37119214e738e8e8c1a206bda99ea1658ccd4a5a2da4c9fee0d65e                                                                                                                  0.0s 
 => => extracting sha256:5c512997c0157e321d7c104e529ca16368f515414f30420421ad0135bee60af5                                                                                                                  0.0s 
 => => extracting sha256:8947a82ab129f041bf3454af1d99685972ee6032fe79e4310150c89ecab8d095                                                                                                                  0.0s 
 => => extracting sha256:4f4fb700ef54461cfa02571ae0db9a0dc1e0cdb5577484a6d75e68dc38e8acc1                                                                                                                  0.0s 
 => => extracting sha256:fff9c052994de414b1a6d4788580900e2d53131fe8bd691ed79eb43f69ace96a                                                                                                                  0.0s 
 => => extracting sha256:07c2d39aacb90c764420be02ee735fac162785301fc27993bc229ec71c119986                                                                                                                  0.5s 
 => => extracting sha256:b33db0b7e8d4ba0867ddd715e5332055576af622cd750f7c72756d3df0496a61                                                                                                                  0.0s 
 => => extracting sha256:d075b4a20d6008e82f23cc72e78ab43d9009d92bbc99883026ead039ff03cb5c                                                                                                                  0.0s 
 => => extracting sha256:c7bafd9d907fce14064c8604352df6543bc0f8baeac507e03fa32a13d6cb67ac                                                                                                                  0.0s 
 => => extracting sha256:32051821f443f3dfca545ff40b2d597e9c07efa80d83cd68030beceea7976a8d                                                                                                                  0.0s 
 => [2/2] COPY . ./                                                                                                                                                                                        0.7s 
 => exporting to image                                                                                                                                                                                     0.2s 
 => => exporting layers                                                                                                                                                                                    0.1s 
 => => writing image sha256:c06fdfdbb336caded5a8005d5721ff8517ea04557a577d86eae4cf031ae27a5b                                                                                                               0.0s 
 => => naming to docker.io/library/awscommunityday:latest                                                                                                                                                  0.0s 

 1 warning found (use docker --debug to expand):
 - LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 6)

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview

anik1@Anik-DevOps MINGW64 /crossplane/project/Appbuild
$ docker tag crossplane-app:latest 309272221538.dkr.ecr.eu-central-1.amazonaws.com/crossplane-app:latest
anik1@Anik-DevOps MINGW64 /crossplane/project/Appbuild
$ docker push 309272221538.dkr.ecr.eu-central-1.amazonaws.com/crossplane-app:latest
The push refers to repository [309272221538.dkr.ecr.eu-central-1.amazonaws.com/crossplane-app]
8491ee891672: Preparing
c58aa4190e5b: Preparing                                                                                                                                                                                         
10c99bd058e6: Preparing                                                                                                                                                                                         
9f86daa0752d: Preparing                                                                                                                                                                                         
5f70bf18a086: Preparing                                                                                                                                                                                         
6d8cbf231743: Preparing                                                                                                                                                                                         
3bf3a187376e: Preparing                                                                                                                                                                                         
de4324344d88: Preparing                                                                                                                                                                                         
9dc9f43bb1f6: Preparing                                                                                                                                                                                         
e86223a295a5: Preparing                                                                                                                                                                                         
6a6800a03291: Preparing                                                                                                                                                                                         
624c46503672: Preparing                                                                                                                                                                                         
d4f19a4830cf: Preparing                                                                                                                                                                                         
e53a079c7b1a: Preparing                                                                                                                                                                                         
29e5758365d0: Preparing                                                                                                                                                                                         
f0b1ce75bc98: Preparing                                                                                                                                                                                         
61e6b0eab41e: Preparing                                                                                                                                                                                         
70f20bb2a1e0: Preparing                                                                                                                                                                                         
8491ee891672: Pushed
c58aa4190e5b: Pushed
10c99bd058e6: Pushed
9f86daa0752d: Pushed
5f70bf18a086: Pushed
6d8cbf231743: Pushed
3bf3a187376e: Pushed
de4324344d88: Pushed
9dc9f43bb1f6: Pushed
e86223a295a5: Pushed
6a6800a03291: Pushed 
624c46503672: Pushed
d4f19a4830cf: Pushed
e53a079c7b1a: Pushed
29e5758365d0: Pushed
f0b1ce75bc98: Pushed
61e6b0eab41e: Pushed
70f20bb2a1e0: Pushed
268a81669311: Pushed
ba9d641e0249: Pushed
f6f51459e171: Pushed
0143f6daf9c3: Pushed
9e6c6a6534f0: Pushed
618fcdcfc107: Pushed
0f0a81d1c3bc: Pushed
4d97e7575552: Pushed
c97da0d72ee3: Pushed
7ab07d3f338c: Pushed
75fd36af67f6: Pushed
2c58b81ad30a: Pushed
latest: digest: sha256:cc370c0a474e2e63fa4f60c90a67399ff911e88abf5e01e16af85073d7f44576 size: 6784
```

Python app Image is now at ECR crossplane-app

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
## use buildspec yaml to automate the build

