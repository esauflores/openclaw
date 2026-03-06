# openclaw

Minimal Docker setup with opinionated tools for running OpenClaw gateway with Tailscale.

## Tools included

- `notesmd-cli` (CLI for managing Obsidian/Markdown notes)
- `d2` (text-to-diagram scripting language)
- `marp` (Markdown presentation converter)

## What this does

- Builds a single `openclaw` container from this repo.
- Starts `tailscaled` inside the container.
- Authenticates to Tailscale when `TS_AUTHKEY` is provided.
- Runs OpenClaw gateway on port `18789` (inside container).

## Project files

```text
openclaw/
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
└── .env.example
```

## Environment

Copy the example file and update values:

```bash
cp .env.example .env
```

### Required

- `TS_AUTHKEY` (recommended for first-time setup)

### Common

- `TS_HOSTNAME` (defaults to `openclaw`)
- `OPENCLAW_STATE_DIR` (defaults to `/openclaw/.openclaw`)

### Optional model/search keys

- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `GEMINI_API_KEY`
- `COPILOT_GITHUB_TOKEN`
- `OPENROUTER_API_KEY`
- `XAI_API_KEY`
- `BRAVE_API_KEY`

## Run

```bash
docker compose up -d --build
```

## First-time setup

After the container is running, execute OpenClaw onboarding once:

```bash
docker compose exec openclaw node dist/index.js onboard
```

You only need this on the first run.

Check logs:

```bash
docker compose logs -f openclaw
```

Stop:

```bash
docker compose down
```

## Notes

- Tailscale state is persisted in Docker volume `openclaw-tailscale-state`.
- OpenClaw data is persisted in Docker volume `openclaw-data`.
- If `TS_AUTHKEY` is omitted, the container uses existing Tailscale state.
