#!/bin/bash
set -e
# Auto-kill all old screen sessions
echo "🧹 Killing old screen sessions..." pkill screen || true
# Install Nexus CLI if not installed
if ! command -v nexus-cli >/dev/null; then echo "📦 Installing Nexus CLI..." curl -s 
  https://cli.nexus.xyz/install.sh | bash source ~/.bashrc
fi
# Install packages
sudo apt update && sudo apt install -y screen netcat
# Start Gitpod keep-alive server
echo "🛡️ Starting keep-alive server..." while true; do echo -e "HTTP/1.1 200 OK\r\n\r\nKeep 
  Alive" | nc -l -p 8080
done &
# List of Node IDs
NODE_IDS=("7896382" "7691701" "7538118" "7377559" "8161206" "6633931" "6694030" "7043877" 
"7842319" "7830090" "7565618" "14629480" "13332269" "13156545" "14997845" "14997846" "14997847" 
"15244908" "15244905" "14997849")
# Start nodes fresh
for i in "${!NODE_IDS[@]}"; do NODE_ID="${NODE_IDS[$i]}" SESSION_NAME="nexusnode$((i+1))" echo 
  "🚀 Starting Node $NODE_ID in screen: $SESSION_NAME" screen -dmS "$SESSION_NAME" nexus-cli 
  start --node-id "$NODE_ID"
done
echo "✅ All nodes started. To view logs: screen -r nexusnode1 (or 2,3...)"

