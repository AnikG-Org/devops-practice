#!/bin/bash

set -e  # Exit on error

# Get all AWS regions
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for REGION in $REGIONS; do
  echo "🔍 Scanning region: $REGION"
  
  # Get all instance IDs in the region
  INSTANCES=$(aws ec2 describe-instances --region $REGION --query "Reservations[].Instances[].InstanceId" --output text)

  if [ -z "$INSTANCES" ]; then
    echo "✅ No instances found in $REGION"
    continue
  fi

  echo "🛑 Disabling termination protection for instances in $REGION..."
  for INSTANCE in $INSTANCES; do
    aws ec2 modify-instance-attribute --region $REGION --instance-id $INSTANCE --no-disable-api-termination \
      || echo "⚠ Skipping instance $INSTANCE due to incorrect state"
  done

  echo "🔥 Terminating instances in $REGION..."
  aws ec2 terminate-instances --region $REGION --instance-ids $INSTANCES

  echo "✅ Instances terminated in $REGION"
done

echo "🚀 All instances in all regions have been processed."
