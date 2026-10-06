# Portfolio content evidence

Reviewed October 6, 2026. Public repository inventory was checked via GitHub's public API, including coursework, forks, and empty repositories. Private repositories were not used for portfolio skill claims. Source inspection supports descriptions; it is not a claim that every project was executed or independently authored without assistance.

## Featured projects

### LanHubHelper

- [README and current scope](https://github.com/jakai211/LanHubHelper)
- [Process manager](https://github.com/jakai211/LanHubHelper/blob/main/backend/manager.py): subprocess ownership, status, graceful stop, settings validation.
- [Installer](https://github.com/jakai211/LanHubHelper/blob/main/backend/installer.py): Mojang metadata, file-size and SHA-1 verification.
- [API](https://github.com/jakai211/LanHubHelper/blob/main/backend/main.py): FastAPI routes and streaming console output.
- [Manager tests](https://github.com/jakai211/LanHubHelper/blob/main/backend/tests/test_manager.py).
- [React interface](https://github.com/jakai211/LanHubHelper/blob/main/frontend/src/App.jsx).

Presented as a development tool; the README explicitly defers real Minecraft gameplay testing. No claims of automatic Java installation, backups, remote access, or multi-server management.

### CrossTunes

- [README](https://github.com/jakai211/CrossTunes): active frontend and environment requirements.
- [Music routes](https://github.com/jakai211/CrossTunes/blob/main/backend/routes/music.js): search integrations, normalized results, input checks, error handling.
- [Spotify routes](https://github.com/jakai211/CrossTunes/blob/main/backend/routes/spotifyAuth.js): account connection flow.
- [Express backend](https://github.com/jakai211/CrossTunes/blob/main/backend/server.js).
- [Active React app](https://github.com/jakai211/CrossTunes/blob/main/frontend/src/App.jsx).

Presented as a college project. Does not claim verified end-to-end playlist transfer, live third-party API availability, or exclusive authorship.

### IS218 Final Project

- [API and web routes](https://github.com/jakai211/IS218-Final-Project/blob/main/main.py): arithmetic, authentication, calculation CRUD and user-scoped queries.
- [Calculation models](https://github.com/jakai211/IS218-Final-Project/blob/main/app/models/calculation.py).
- [Browser tests](https://github.com/jakai211/IS218-Final-Project/blob/main/tests/e2e/test_e2e.py).
- [Workflow](https://github.com/jakai211/IS218-Final-Project/blob/main/.github/workflows/test.yml): pytest, Playwright, Docker build configuration.

Presented as coursework, not a production service. Python and FastAPI recur across the coursework series and LanHubHelper; React and JavaScript recur in CrossTunes and LanHubHelper.

## Selection boundaries

- IS218 midterm and weekly/module repositories contain earlier calculator iterations; the final project represents the series rather than showing duplicates.
- Game-Mod-Q4 and rabbitmqphp_example are forks. Inherited source alone is not evidence of personal proficiency; they were not used to claim C++ or RabbitMQ expertise.
- SteamTrophies contains an early web interface and RabbitMQ example files, with a minimal README. It was not selected over the better-documented projects.
- IT340 lab repositories were reviewed as coursework and not promoted above the larger projects; Angular/TypeScript template presence alone was not used for proficiency claims.
- Empty repositories and duplicate CrossTunes-main were omitted.
- C, Linux, Git, employment, education, basic French, and personal details came directly from Jakai's supplied brief.
