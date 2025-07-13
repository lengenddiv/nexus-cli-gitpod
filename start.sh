#!/bin/bash
set -e

echo "Killing old screen sessions..."
pkill screen || true

echo "Installing required packages..."
sudo apt update
sudo apt install -y screen netcat

echo -e "HTTP/1.1 200 OK\r\n\r\nKeep Alive" | nc -l -p 8080; do :; done &

echo "Launching Nexus CLI nodes..."
NODE_IDS=(
  "6633931" "6694030" "7043877" "7538118" "7377559"
  "7897705" "7842319" "7830090" "7565618"
  "14629480" "13332269" "13156545" "8161206"
  "14997845" "14997846" "14997847"
  "15244908" "15244905" "14997849"
)
for i in "${!NODE_IDS[@]}"; do
  node="${NODE_IDS[$i]}"
  session="nexusnode$((i+1))"
  screen -dmS "$session" bash -c "nexus-cli start --node-id $node"
  echo "🚀 Started node $node in session $session"
done

echo "✅ All nodes launched. Use 'screen -r nexusnode1' to view logs"
