#!/bin/bash

set -e

# -------- Configuration --------
TAG_ENV="pre"
RESOURCE_NAME="aws_instance.web"
REGION="ap-south-1"
TF_RESOURCE_COUNT=2  # Change this based on how many EC2s you expect

# -------- Fetch matching EC2 instances --------
echo "🔍 Fetching EC2 instances with tag Environment=$TAG_ENV ..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --region "$REGION" \
  --filters Name=tag:Environment,Values="$TAG_ENV" \
  --query 'Reservations[*].Instances[*].InstanceId' \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "❌ No instances found with tag Environment=$TAG_ENV"
  exit 1
fi

echo "✅ Found instances: $INSTANCE_IDS"
echo "🧠 Validating against Terraform state..."
# -------- Check and Import each instance --------
INDEX=0
for INSTANCE_ID in $INSTANCE_IDS; do
  TF_ADDRESS="module.compute.${RESOURCE_NAME}[${INDEX}]"

  # Check if this address already exists in state
  if terraform state list | grep -q "$TF_ADDRESS"; then
    echo "✅ $TF_ADDRESS already exists in state — skipping import."
  else
    echo "➡️  Importing $TF_ADDRESS => $INSTANCE_ID"
    terraform import "$TF_ADDRESS" "$INSTANCE_ID"
  fi

  ((INDEX++))

  # Optional safety check: don't go beyond declared count
  if [ "$INDEX" -ge "$TF_RESOURCE_COUNT" ]; then
    echo "⚠️ Reached max count ($TF_RESOURCE_COUNT) — stopping further imports."
    break
  fi
done

echo "🎉 Done: All missing EC2 instances have been imported."