#!/bin/bash
set -e

# Ensure Nexus CLI is installed
if ! command -v nexus-cli >/dev/null; then
  echo "📦 Installing Nexus CLI..."
  curl -s https://cli.nexus.xyz/install.sh | bash
  echo 'export PATH="$HOME/.nexus/bin:$PATH"' >> ~/.bashrc
  export PATH="$HOME/.nexus/bin:$PATH"
fi

# Install required packages
sudo apt update && sudo apt install -y screen netcat

# Start keep-alive to prevent Gitpod timeout
echo "🛡️ Starting keep-alive server..."
nohup sh -c 'while true; do echo -e "HTTP/1.1 200 OK\r\n\r\nKeep Alive" | nc -l -p 8080; done' >/dev/null 2>&1 &

# List of Node IDs
NODE_IDS=("6633931" "6694030" "7043877" "7538118" "7377559" "7897705" "7842319" "7830090" "7565618" "14629480" "13332269" "13156545" "8161206")

# Start each node in a screen session
for i in "${!NODE_IDS[@]}"; do
  NODE_ID="${NODE_IDS[$i]}"
  SESSION_NAME="nexusnode$((i+1))"
  echo "🚀 Starting Node $NODE_ID in screen: $SESSION_NAME"
  screen -dmS "$SESSION_NAME" bash -c "nexus-cli start --node-id $NODE_ID"
done

echo "✅ All nodes started. To view logs: screen -r nexusnode1 (or 2,3,...)"
