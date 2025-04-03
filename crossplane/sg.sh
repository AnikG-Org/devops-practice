#!/bin/bash

set -e  # Exit on error

# Get all AWS regions
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for REGION in $REGIONS; do
  echo "🔍 Checking region: $REGION"

  # Get the default VPC ID
  DEFAULT_VPC_ID=$(aws ec2 describe-vpcs --region $REGION --filters Name=isDefault,Values=true --query "Vpcs[0].VpcId" --output text)

  if [ "$DEFAULT_VPC_ID" == "None" ]; then
    echo "🚫 No default VPC found in $REGION, skipping..."
    continue
  fi

  echo "🛠 Found default VPC: $DEFAULT_VPC_ID in $REGION"

  # Get security groups in the default VPC
  SECURITY_GROUPS=$(aws ec2 describe-security-groups --region $REGION --filters "Name=vpc-id,Values=$DEFAULT_VPC_ID" --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)

  if [ -z "$SECURITY_GROUPS" ]; then
    echo "✅ No extra security groups found in default VPC for $REGION."
    continue
  fi

  echo "🔥 Deleting non-default security groups in $REGION..."
  for SG_ID in $SECURITY_GROUPS; do
    echo "🗑 Deleting Security Group: $SG_ID in $REGION"
    aws ec2 delete-security-group --region $REGION --group-id $SG_ID \
      || echo "⚠ Failed to delete $SG_ID (possibly in use)"
  done

  echo "✅ Cleanup completed for $REGION."
done

echo "🚀 All non-default security groups in default VPCs have been processed."