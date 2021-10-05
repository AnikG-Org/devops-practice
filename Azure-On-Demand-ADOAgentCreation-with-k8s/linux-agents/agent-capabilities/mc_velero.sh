#!/bin/bash
set -euo pipefail

if [ -z $AILAB_JFROG_PASSWORD ]; then
  echo 1>&2 "error: missing AILAB_JFROG_PASSWORD environment variable"
  exit 1
fi

if [ -z $JFROG_USER ]; then
  echo 1>&2 "error: missing JFROG_USER environment variable"
  exit 1
fi

## poc Certificates ##
cd /files/cert
mkdir -p /etc/pki/ca-trust/source/anchors/
mkdir -p /usr/local/share/ca-certificates/
cp * /etc/pki/ca-trust/source/anchors/
cp * /usr/local/share/ca-certificates/
update-ca-certificates
python3 addbundle.py



## Installing mc ##
cd /files
curl --user "$JFROG_USER:$AILAB_JFROG_PASSWORD" https://artifacts-west.poc.com/artifactory/w00003-poc-us-ailab-generic/minio/mc.RELEASE.2021-05-12T03-10-11Z -o mc
chmod +x mc
mv mc /usr/local/bin/mc
mc -v

## Installing Velero ##

cd /files
curl --user "$JFROG_USER:$AILAB_JFROG_PASSWORD" https://artifacts-west.poc.com/artifactory/w00003-poc-us-ailab-generic/velero/velero-v1.6.0-linux-amd64.tar.gz  -o velero-v1.6.0-linux-amd64.tar.gz
tar -xzvf velero-v1.6.0-linux-amd64.tar.gz
rm -rf velero-v1.6.0-linux-amd64.tar.gz
chmod +x velero-v1.6.0-linux-amd64/velero
cp velero-v1.6.0-linux-amd64/velero /usr/local/bin/velero
rm -rf velero-v1.6.0-linux-amd64