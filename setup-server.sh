#!/usr/bin/env bash
# Run on a fresh Ubuntu 24.04 Droplet, from this repository directory.
set -euo pipefail
cd -- "$(dirname -- "$0")"
if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo bash setup-server.sh" >&2
  exit 1
fi
for file in index.html routes.yml; do
  test -f "$file"
done
export DEBIAN_FRONTEND=noninteractive
if [ ! -f /swapfile ]; then
  fallocate -l 1G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  printf '/swapfile none swap sw 0 0\n' >> /etc/fstab
fi
apt-get update
apt-get install -y docker.io ufw
systemctl enable --now docker
ufw default deny incoming
ufw default allow outgoing
ufw limit 22/tcp
ufw allow 80/tcp
ufw --force enable
mkdir -p /opt/cafe/html /opt/cafe/config
cp index.html /opt/cafe/html/index.html
cp routes.yml /opt/cafe/config/routes.yml
docker network inspect cafe-network >/dev/null 2>&1 || docker network create cafe-network
docker run -d --name cafe-web --restart unless-stopped --network cafe-network --memory 64m --log-opt max-size=5m --log-opt max-file=2 -v /opt/cafe/html:/usr/share/nginx/html:ro nginx:stable-alpine
docker run -d --name cafe-proxy --restart unless-stopped --network cafe-network --memory 160m --log-opt max-size=5m --log-opt max-file=2 -p 80:80 -v /opt/cafe/config:/etc/traefik/dynamic:ro traefik:v3.7 --entrypoints.web.address=:80 --providers.file.directory=/etc/traefik/dynamic --api.dashboard=false --log.level=INFO
echo "Installed. Open http://YOUR_SERVER_IP in a browser."
