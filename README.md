# Little Hours

A simple fictional café website, self-hosted on DigitalOcean with Docker, Nginx, and Traefik. No database, login, or build step.

**Live demo:** http://138.197.134.214/

## How it works

Visitors → Traefik (port 80) → Nginx → `index.html`

The demo uses a $4/month DigitalOcean Droplet in Toronto with Ubuntu 24.04, 512 MB RAM, and 10 GB storage. Taxes or usage extras may apply. It uses the server IP over HTTP; a custom domain and HTTPS are not configured.

## Files

- `index.html` — the website, styles, and coffee illustration.
- `routes.yml` — Traefik routing configuration.
- `setup-server.sh` — installs the same server layout on a fresh Ubuntu Droplet.
- `compose.yaml` — an alternative way to run the site using Docker Compose.

## Preview

Open `index.html` in your browser. To run through Traefik instead, install Docker with Compose and run:

```sh
docker compose up -d
```

Then open http://localhost. Stop it with `docker compose down`.

## Deploy on a new DigitalOcean server

1. Create an Ubuntu 24.04 Droplet and set up your own server authentication.
2. Copy this repository's files onto the server.
3. From the repository directory, run:

```sh
sudo bash setup-server.sh
```

4. Open `http://YOUR_SERVER_IP`.

The script installs Docker, adds 1 GB of swap, configures the firewall for SSH and HTTP, and starts both containers. Use it on a fresh server, not one already running this demo. Choose either this script or Compose; both need port 80 and should not run together.

## Update the existing demo

The deployed website lives at `/opt/cafe/html/index.html`, and routing is in `/opt/cafe/config/routes.yml`. Replace the HTML file with your updated version, saved as UTF-8, then refresh your browser. Uploading changes to GitHub does not automatically update the server.

To check the running containers on the existing server:

```sh
docker ps
docker logs cafe-proxy
```

Keep passwords and SSH private keys out of the repository. The café and menu are fictional; this demo does not accept orders or payments.
