#!/usr/bin/env bash
# One-time migration for the existing cafe containers. Does not alter SSH access.
set -euo pipefail
test "$EUID" -eq 0 || { echo "Run from the existing root web console"; exit 1; }
cd -- "$(dirname -- "$0")/.."
test "$(pwd -P)" = /opt/portfolio || { echo "Extract repository into /opt/portfolio first"; exit 1; }
test ! -e state/initialized || { echo "Already initialized; use release.sh"; exit 1; }
docker compose version
id jakai
docker inspect cafe-proxy >/dev/null
docker inspect cafe-web >/dev/null
test "$(docker inspect -f '{{.State.Running}}' cafe-proxy)" = true
test "$(docker inspect -f '{{.State.Running}}' cafe-web)" = true
python3 scripts/validate.py
mkdir -p state backups
backup="backups/cafe-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir "$backup"
docker inspect cafe-proxy cafe-web > "$backup/containers.json"
cp -a /opt/cafe "$backup/"
docker network inspect portfolio-edge >/dev/null 2>&1 || docker network create portfolio-edge
docker build --build-arg REVISION=bootstrap -t portfolio:bootstrap .
docker compose -p portfolio-edge -f deploy/proxy.yaml pull
for environment in qa production; do
  test ! -e "state/$environment.env" || { echo "State already exists; inspect before retrying"; exit 1; }
  printf 'SITE_ENV=%s\nSITE_IMAGE=portfolio:bootstrap\n' "$environment" > "state/$environment.env"
  docker compose -p "portfolio-$environment" -f deploy/site.yaml --env-file "state/$environment.env" up -d --wait --wait-timeout 90
done
# Both new sites are healthy before the old proxy releases ports.
rollback() {
  echo "Migration failed; restoring the original HTTP site" >&2
  docker compose -p portfolio-edge -f deploy/proxy.yaml down || true
  docker start cafe-proxy
}
trap rollback ERR
docker stop cafe-proxy
docker compose -p portfolio-edge -f deploy/proxy.yaml up -d --wait --wait-timeout 90
for domain in j5port.duckdns.org j5port-qa.duckdns.org; do
  curl --fail --silent --show-error --retry 20 --retry-all-errors --retry-delay 5 --max-time 15 "https://$domain/version.txt" > "state/$domain.version"
  test "$(cat "state/$domain.version")" = bootstrap
done
touch state/initialized
trap - ERR
docker stop cafe-web
docker update --restart=no cafe-web cafe-proxy
echo "Both HTTPS sites verified. SSH access is unchanged."
echo "Old cafe containers and backups are retained for rollback."
