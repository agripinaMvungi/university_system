#!/bin/sh
# This script will be run when the container starts
# It sets the X-Node-ID header based on the container hostname

# Get the hostname (we'll use this as the node ID)
NODE_ID=$(hostname)

# Replace the placeholder in the nginx config with the actual node ID
sed -i "s/__NODE_ID__/$NODE_ID/g" /etc/nginx/conf.d/default.conf

# Also set a cookie with the node ID
echo "X-Node-ID=$NODE_ID; Path=/" > /usr/share/nginx/html/node-id.txt