#!/usr/bin/env bash

set -e

export AWS_DEFAULT_REGION="us-east-2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
user_data=$(cat "$SCRIPT_DIR/user-data.sh")

security_group_name="sample-app"

# Try to find an existing security group with the same name. If none found, create it.
security_group_id=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=${security_group_name}" \
  --query 'SecurityGroups[0].GroupId' \
  --output text 2>/dev/null || true)

if [ -z "$security_group_id" ] || [ "$security_group_id" = "None" ]; then
  security_group_id=$(aws ec2 create-security-group \
    --group-name "$security_group_name" \
    --description "Allow HTTP traffic into the sample app" \
    --output text \
    --query GroupId)

  aws ec2 authorize-security-group-ingress \
    --group-id "$security_group_id" \
    --protocol tcp \
    --port 80 \
    --cidr "0.0.0.0/0" > /dev/null
fi

instance_id=$(aws ec2 run-instances \
  --image-id "ami-0900fe555666598a2" \
  --instance-type "t3.micro" \
  --security-group-ids "$security_group_id" \
  --user-data "$user_data" \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=sample-app}]' \
  --output text \
  --query Instances[0].InstanceId)

public_ip=$(aws ec2 describe-instances \
  --instance-ids "$instance_id" \
  --output text \
  --query 'Reservations[*].Instances[*].PublicIpAddress')

echo "Instance ID = $instance_id"
echo "Security Group ID = $security_group_id"
echo "Public IP = $public_ip"
