#!/usr/bin/env bash
# Install once at /opt/portfolio/deploy/release.sh; run as jakai after SSH setup.
set -euo pipefail
environment="${1:?Usage: release.sh qa|production IMAGE REVISION}"
image="${2:?Missing image digest}"
revision="${3:?Missing revision}"
case "$environment" in
  qa) domain=j5port-qa.duckdns.org ;;
  production) domain=j5port.duckdns.org ;;
  *) echo "Invalid environment" >&2; exit 1 ;;
esac
[[ "$image" =~ ^ghcr.io/jakai211/little-hours-demo@sha256:[a-f0-9]{64}$ ]] || exit 1
[[ "$revision" =~ ^[a-f0-9]{40}$ ]] || exit 1
cd /opt/portfolio
mkdir -p state
exec 9>"state/$environment.lock"
flock -w 300 9
state="state/$environment.env"
test -f "$state"
candidate="state/$environment.next.env"
cp "$state" "state/$environment.previous.env"
printf 'SITE_ENV=%s\nSITE_IMAGE=%s\n' "$environment" "$image" > "$candidate"
compose=(docker compose -p "portfolio-$environment" -f deploy/site.yaml)
docker pull "$image"
if "${compose[@]}" --env-file "$candidate" up -d --wait --wait-timeout 90 &&
   test "$(curl --fail --silent --show-error --retry 5 --retry-all-errors --retry-delay 3 --max-time 15 "https://$domain/version.txt")" = "$revision"; then
  mv "$candidate" "$state"
  echo "Deployed $environment at $revision"
else
  echo "Deployment failed; restoring previous image" >&2
  "${compose[@]}" --env-file "$state" up -d --wait --wait-timeout 90
  exit 1
fi
