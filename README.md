# Jakai F. — Personal Portfolio

A responsive, dark portfolio for an Information Technology student at NJIT, graduating June 2027. Built with plain HTML and CSS; no build tools, external fonts, tracking, or database required.

## Preview and edit

Open `index.html` in a browser. All content and styles are in that file.

- Search for `EDIT EMAIL` to replace `your.email@example.com`. Until then, LinkedIn is the contact method.
- Each `<article class="project">` is a featured project.
- Update the Skills, Education, and Experience sections as your experience grows.
- Colors are defined at the beginning of the `<style>` block.

Project descriptions were checked against public repository source on October 6, 2026. See `PROJECT-SOURCES.md` for evidence and selection notes. No proficiency ratings or unverified certifications are claimed.

## Hosting

Server address: http://138.197.134.214/

Visitors → Traefik on port 80 → Nginx → `index.html`

The existing server is a $4/month DigitalOcean Ubuntu 24.04 Droplet in Toronto (512 MB RAM, 10 GB storage). Taxes or usage extras may apply. The site currently uses HTTP and the server's IP address; domain and HTTPS setup are separate.

The repository retains its original name, `little-hours-demo`. Container names and `/opt/cafe` paths are also retained for compatibility with the original deployment.

### Update the existing server

Replace `/opt/cafe/html/index.html` with this repository's `index.html`, saved as UTF-8. Back up the old file first. No container restart is required.

GitHub changes do **not** automatically deploy. Never paste passwords or private keys into the repository.

### Run with Docker Compose

With Docker and Compose installed, run `docker compose up -d` from this directory, then open http://localhost. Stop with `docker compose down`.

### Set up a fresh Ubuntu server

Copy these files onto a fresh Ubuntu 24.04 Droplet and run `sudo bash setup-server.sh`. The script installs Docker, adds swap, configures SSH/HTTP firewall rules, and starts Nginx and Traefik.

Choose either the setup script or Compose. Do not run both together; both use port 80. Do not rerun the fresh-server script on the existing server.
