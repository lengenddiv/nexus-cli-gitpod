#!/bin/bash
set -e

# Download Nexus CLI
if [ ! -f nexus ]; then
  echo "📦 Downloading Nexus CLI..."
  wget -q https://cli.nexus.xyz/ | sh
fi

# Keep-alive server on port 8080
echo "⚙️ Starting keep-alive server..."
while true; do 
  echo -e "HTTP/1.1 200 OK\r\n\r\nKeep Alive" | nc -l -p 8080
done &

# Start Nexus CLI in screen
echo "🚀 Starting Nexus CLI in screen..."
screen -dmS nexusnode nexus-cli start

echo "✅ Setup done. Run 'screen -r nexusnode' to view lo
gs."
