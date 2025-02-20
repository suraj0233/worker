#!/bin/bash
set -eux  # Enable debugging mode

# Update and install dependencies
sudo apt update && sudo apt install -y curl wget

# Download the Spacelift Launcher
sudo wget -O /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
sudo chmod +x /usr/local/bin/spacelift-launcher

# Retrieve Spacelift credentials from environment variables
SPACELIFT_ACCESS_KEY="${SPACELIFT_ACCESS_KEY}"
SPACELIFT_SECRET_KEY="${SPACELIFT_SECRET_KEY}"
WORKER_POOL_ID="${WORKER_POOL_ID}"

# Verify that all required values are available
if [[ -z "$SPACELIFT_ACCESS_KEY" || -z "$SPACELIFT_SECRET_KEY" || -z "$WORKER_POOL_ID" ]]; then
  echo "Error: Required Spacelift credentials or Worker Pool ID are missing!"
  exit 1
fi

# Export the credentials to the environment
echo "export SPACELIFT_ACCESS_KEY=${SPACELIFT_ACCESS_KEY}" | sudo tee -a /etc/environment
echo "export SPACELIFT_SECRET_KEY=${SPACELIFT_SECRET_KEY}" | sudo tee -a /etc/environment
echo "export WORKER_POOL_ID=${WORKER_POOL_ID}" | sudo tee -a /etc/environment

# Create the Spacelift configuration file
cat <<EOF | sudo tee /etc/spacelift-config.json
{
  "access_key": "${SPACELIFT_ACCESS_KEY}",
  "secret_key": "${SPACELIFT_SECRET_KEY}"
}
EOF

# Reload environment variables
source /etc/environment

# Register the Spacelift Worker
sudo -E /usr/local/bin/spacelift-launcher register --worker-pool "${WORKER_POOL_ID}"
