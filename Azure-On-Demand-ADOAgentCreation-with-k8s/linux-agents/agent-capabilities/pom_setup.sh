#!/bin/bash

set -euo pipefail

## Configure maven settings xml

if [ -z $AILAB_JFROG_PASSWORD ]; then
  echo 1>&2 "error: missing AILAB_JFROG_PASSWORD environment variable"
  exit 1
fi

mkdir -p /home/ailabs/.m2
echo '<?xml version="1.0" encoding="UTF-8"?>
<settings xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd"
	xmlns="http://maven.apache.org/SETTINGS/1.1.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<servers>
		<server>
			<username>pailabs001</username>
			<password>$AILAB_JFROG_PASSWORD</password>
			<id>central</id>
		</server>
		<server>
			<username>pailabs001</username>
			<password>$AILAB_JFROG_PASSWORD</password>
			<id>snapshots</id>
		</server>
	</servers>
	<activeProfiles>
		<activeProfile>artifactory</activeProfile>
	</activeProfiles>
</settings>' > /home/ailabs/.m2/settings.xml

#chown -R ailabs:ailabs /home/ailabs/.m2
