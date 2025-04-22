#!/bin/bash

LOGFILE="/var/log/startup-script.log"

# Check if the script has already been executed
if grep -q "Startup script executed" "$LOGFILE"; then
    echo "The script has already been executed before. Exiting..."
    exit 0
fi

echo "Running installation script..." | tee -a "$LOGFILE"

# Update the system
echo "Updating the system..."
sudo apt update -y && sudo apt upgrade -y

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
echo "Installing Docker Compose..."
sudo apt install -y docker-compose

# Install WireGuard
echo "Installing WireGuard..."
sudo apt install -y wireguard

# Mark that the script has been executed
echo "Startup script executed" | tee -a "$LOGFILE"

echo "Installation completed."