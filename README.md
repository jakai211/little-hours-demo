# Jakai F. — Personal Portfolio

**[Production](https://j5port.duckdns.org) · [QA](https://j5port-qa.duckdns.org)**

A responsive portfolio for an Information Technology student at NJIT, graduating June 2027. Plain HTML and CSS, with no database, tracking, external fonts or frontend build tools.

## Deployment status

The repository includes the QA/production setup. Live HTTPS migration, deployment credentials and SSH verification must be completed using [DEPLOYMENT.md](DEPLOYMENT.md). Links above are the intended endpoints; a committed configuration alone does not prove they are live.

## Edit the portfolio

Open `index.html` in a browser. Content and styles are in that file.
- Search for `EDIT EMAIL` to replace the contact placeholder. LinkedIn is the current contact method.
- Each `article.project` is a featured project.
- Update Skills, Education and Experience as your experience grows.
- Colors are defined at the beginning of the style block.

Project descriptions were checked against public repository source on October 6, 2026. See [PROJECT-SOURCES.md](PROJECT-SOURCES.md).

## QA and production

Push website changes to `qa` to validate, build, publish to GitHub Container Registry and deploy QA. Inspect QA, then approve and merge a pull request from `qa` into `main` to deploy production. Branch protection/review enforcement must be configured separately; this is the promotion policy.

The workflow builds once, tests the running image, publishes it, then deploys its exact digest. Failed validation, build or smoke tests stop publishing and deployment. The deployment job remains disabled until repository variable `DEPLOY_ENABLED=true` is set after server and SSH setup.

Production and QA run as separate Compose projects with independent image state. One Traefik proxy routes their hostnames, redirects HTTP to HTTPS and persists Let's Encrypt certificates. Updating QA does not restart production or the proxy. A failed release restores that environment's previous image.

## Files

- `Dockerfile`: website image and health check.
- `.github/workflows/deploy.yml`: validation, image build, test, registry push and SSH deployment.
- `deploy/`: separate sites, HTTPS proxy, one-time migration and release script.
- `scripts/validate.py`: page structure and internal-link validation.
- [DEPLOYMENT.md](DEPLOYMENT.md): setup, rollback and evidence.

The original `compose.yaml`, `routes.yml` and `setup-server.sh` are legacy HTTP examples. **Do not run them on the migrated server.** The fresh-server script is not a migration script.
