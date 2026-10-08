# Deploy the existing DigitalOcean Droplet

Server: `138.197.134.214`, Ubuntu 24.04. Production: `j5port.duckdns.org`. QA: `j5port-qa.duckdns.org`. Certificate email: `jbf8@njit.edu`.

## 1. Prepare and migrate HTTPS first

Use the existing root DigitalOcean Web Console. Keep it open. The migration does not edit SSH configuration, users, keys or SSH firewall rules.

Both DNS A records must resolve to the server. Remove incorrect AAAA records if present. Allow inbound TCP 80 and 443 in any DigitalOcean firewall. Preserve the existing SSH rule.

Install Compose from Ubuntu's package repository:

```bash
apt-get update && apt-get install -y docker-compose-v2 curl python3
docker compose version
```

Download a **tested commit** of this repository into a new, empty `/opt/portfolio` directory. Do not overwrite an existing installation. Replace COMMIT below with the reviewed 40-character commit:

```bash
(
set -eu
test ! -e /opt/portfolio
mkdir /opt/portfolio
curl -fL https://github.com/jakai211/little-hours-demo/archive/COMMIT.tar.gz -o /tmp/portfolio-source.tar.gz
tar -xzf /tmp/portfolio-source.tar.gz --strip-components=1 -C /opt/portfolio
ufw allow 80/tcp
ufw allow 443/tcp
cd /opt/portfolio
bash deploy/bootstrap.sh
)
```

Bootstrap backs up `/opt/cafe` and the old container settings, builds the initial image and starts both new site containers. Only after they are healthy does it stop `cafe-proxy` and start the HTTPS proxy. It verifies trusted HTTPS on both domains and restores the old HTTP proxy if this part fails. A failed attempt leaves files/state for inspection; do not blindly rerun it.

After successful HTTPS checks, bootstrap stops the old `cafe-web` container to free memory and disables automatic restart for both old containers to prevent port conflicts after reboot. Both old containers are retained for rollback.

## 2. Verify the sites

```bash
curl -fsS https://j5port.duckdns.org/version.txt
curl -fsS https://j5port-qa.duckdns.org/version.txt
curl -I http://j5port.duckdns.org
docker compose -p portfolio-edge -f /opt/portfolio/deploy/proxy.yaml logs --tail=60
```

Initial version responses are `bootstrap`; after automatic deployment they are Git commit IDs. Open both HTTPS sites from another computer too. Never use `curl -k` as proof of working HTTPS.

## 3. Finish SSH last

Only after both sites work:
1. Create a passphrase-protected personal SSH key on your trusted Windows account and install its public key for `jakai`.
2. Test a new SSH session as `jakai` and test `sudo -v`. Keep the root Web Console open.
3. Create a separate deployment key. Put its public key in `jakai`'s authorized keys. Put only the private key in GitHub Actions secret `DEPLOY_SSH_KEY`; never commit or paste it into chat.
4. Give `jakai` deployment access: `usermod -aG docker jakai` and `chown -R jakai:jakai /opt/portfolio/state`. Docker-group membership grants root-equivalent Docker control. New sessions pick up the group. Keep deployment scripts owned by root.
5. Verify the server's Ed25519 host fingerprint in the trusted Web Console (`ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub`). Construct a known_hosts line for `138.197.134.214` from that public key and store it in Actions secret `SSH_KNOWN_HOSTS`. Do not trust an unverified network key scan.
6. Test key login and Docker access as `jakai` before disabling root/password SSH. Review effective `sshd -T` settings and included config ordering. Validate configuration with `sshd -t`, reload SSH, then test another new `jakai` session before closing recovery access. Verify effective `permitrootlogin no`, `passwordauthentication no`, `kbdinteractiveauthentication no`, `pubkeyauthentication yes`.

Do not disable login methods until the new key and sudo access have actually been tested.

## 4. Enable GitHub deployment

Create the `qa` branch from the completed setup on `main`. Create GitHub environments `qa` and `production`. Configure production to accept `main` and QA to accept `qa`; add branch protection/review rules as available.

The workflow uses its built-in `GITHUB_TOKEN` with `packages: write` to publish. No registry password is committed. After its first publish, set the GitHub Container Registry package `little-hours-demo` to public so the Droplet can pull without registry credentials. A public repository does not automatically make the package public. Alternatively, authenticate `jakai` to GHCR privately using a read-packages token; do not store it in the repository.

Add the two SSH secrets described above. After SSH and registry access are verified, set repository Actions variable `DEPLOY_ENABLED` to `true`. Before that, builds/publishing may run but deployment is intentionally skipped.

Run the workflow on `qa`, inspect QA, then promote through a reviewed pull request into `main`. Use the Actions run page and both `version.txt` endpoints to verify the deployed commits. Routine deployment changes only the selected site. Infrastructure files are installed once; review and apply future infrastructure changes manually.

## Rollback

A failed deployment attempts to restore the previous image automatically. To manually restore the previous release:

```bash
cd /opt/portfolio
# Replace qa with production only when rolling back production.
cp state/qa.env state/qa.failed.env
cp state/qa.previous.env state/qa.env
docker compose -p portfolio-qa -f deploy/site.yaml --env-file state/qa.env up -d --wait
```

To restore the original HTTP site from the root console:

```bash
docker compose -p portfolio-edge -f /opt/portfolio/deploy/proxy.yaml down
docker start cafe-web cafe-proxy
docker update --restart=unless-stopped cafe-web cafe-proxy
```

Never run `down -v` for the proxy: its certificate volume must persist. Retain the previous image when cleaning old images from the 10 GB disk.

## Evidence checklist

Record actual results; do not claim completion until tested:
- Public repository homepage links to production and QA.
- Both HTTPS sites load with trusted certificates.
- Actions run shows validation, build, image test, publish and successful deployment.
- QA-only change changes QA's version/content while production stays unchanged.
- Promotion to main updates production.
- A deliberately broken validation in a temporary PR fails without deployment.
- Non-root key login and sudo work; effective SSH settings reject root/password login.
- Share screenshots/logs without private keys, tokens or passwords.
