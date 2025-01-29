#!/bin/bash

# Config
SERVER_URL="https://api.papermc.io/v2/projects/paper/versions/1.18.2/builds/388/downloads/paper-1.18.2-388.jar"
SERVER_JAR="/opt/minecraft_server.jar"
JRE_URL="https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.deb"
JRE_FILE="/tmp/jdk17.deb"
LOG_FILE="/var/log/minecraft-setup.log"
EULA_FILE="/opt/minecraft/eula.txt"

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Attempting to re-run with sudo..."
  exec sudo bash "$0" "$@"
  exit
fi

# Log setup to file
exec > >(tee -a "$LOG_FILE") 2>&1
echo "Starting Minecraft server setup..."

# Update and install dependencies
echo "Updating package lists..."
apt-get update -y

echo "Checking for wget..."
if ! command -v wget &> /dev/null; then
    echo "wget not found, installing..."
    apt-get install -y wget
else
    echo "wget is already installed."
fi

echo "Checking for tmux..."
if ! command -v tmux &> /dev/null; then
    echo "tmux not found, installing..."
    apt-get install -y tmux
else
    echo "tmux is already installed."
fi

# Download and install JRE 17
echo "Downloading JDK 17 from $JRE_URL..."
wget -O "$JRE_FILE" "$JRE_URL"

echo "Installing JDK 17..."
dpkg -i "$JRE_FILE" || apt-get install -f -y

echo "Verifying Java installation..."
java -version || { echo "Java installation failed!"; exit 1; }

# Download Minecraft server JAR
echo "Downloading Minecraft server from $SERVER_URL..."
mkdir -p /opt/minecraft
wget -O "$SERVER_JAR" "$SERVER_URL"

# Run the server to generate eula.txt
echo "Running Minecraft server to generate eula.txt..."
cd /opt/minecraft
java -jar "$SERVER_JAR" || true

# Accept the EULA
if [ -f "$EULA_FILE" ]; then
    echo "Accepting the EULA..."
    sed -i 's/eula=false/eula=true/' "$EULA_FILE"
else
    echo "EULA file not found. Something went wrong during server setup."
    exit 1
fi

# Run the server again
echo "Starting Minecraft server..."
tmux new-session -d -s minecraft "java -jar $SERVER_JAR"

# Verify tmux session creation
tmux ls

# Debugging: Check the exit status of the tmux command
if [ $? -ne 0 ]; then
    echo "Failed to create tmux session."
else
    echo "tmux session created successfully, attaching to it..."
    tmux attach-session -t minecraft
fi

echo "Minecraft server setup complete."