#!/bin/bash
set -e

echo "Killing old screen sessions..."
pkill screen || true

echo "Installing required packages..."
sudo apt update
sudo apt install -y screen netcat

# Start keep-alive server
while echo -e "HTTP/1.1 200 OK\r\n\r\nKeep Alive" | nc -l -p 8080; do :; done &
echo "Launching Nexus CLI nodes..."
NODE_IDS=(
 "14629321" "14712986" "14575208" "14803946" "14824887"
  "14382119" "14410295" "14157576" "14492606" "14157585"
)
for i in "${!NODE_IDS[@]}"; do
  node="${NODE_IDS[$i]}"
  session="nexusnode$((i+1))"
  screen -dmS "$session" bash -c "nexus-cli start --node-id $node"
  echo "🚀 Started node $node in session $session"
done

echo "✅ All nodes launched. Use 'screen -r nexusnode1' to view logs"
