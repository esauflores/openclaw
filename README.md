# openclaw

**Custom, opinionated setup**: OpenClaw gateway with FileBrowser and Tailscale for internal access. This configuration is tailored to personal preferences and may differ from standard deployments.

## Architecture

This project uses a modular Docker Compose setup with three main components:

```
openclaw/                   # Main gateway (runs Tailscale + OpenClaw)
├── docker-compose.yml      # Main orchestration
├── Dockerfile              # OpenClaw + Tailscale
├── entrypoint.sh
├── dev-tools/              # Development tools container (shared volume)
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── mise.toml           # Tool definitions (Node 24, Python 3.11, Go, etc.)
└── filebrowser/            # Standalone file browser UI
    ├── docker-compose.yml
    ├── Dockerfile
    └── entrypoint.sh
```

## Services

| Service       | Role                                                              |
| ------------- | ----------------------------------------------------------------- |
| `openclaw`    | Main gateway with Tailscale VPN access to internal network        |
| `filebrowser` | Web-based file browser for browsing/managing files via browser UI |
| `dev-tools`   | Build container that creates shared volume mounted into openclaw  |

### Dev-Tools Integration

The `dev-tools` container is opinionated and provides:

- **Languages**: Node 24, Python 3.11, Go 1.26, DuckDB
- **Package managers**: uv
- **Utilities**: sops, age, mc, Supabase CLI, bat, eza, ripgrep, fzf, jq, yq, starship, gh

This container builds once and creates a persistent Docker volume. The tools are mounted read-only into the `openclaw` container so they're available during gateway operations.

## Environment Variables

### OpenClaw & Tailscale

| Variable      | Description                                                                             |
| ------------- | --------------------------------------------------------------------------------------- |
| `TS_AUTHKEY`  | Auth key from [Tailscale admin → Keys](https://login.tailscale.com/admin/settings/keys) |
| `TS_HOSTNAME` | Node name that will appear in your Tailscale admin panel                                |
| `PUID`        | User ID for file permissions (default: `1000`)                                          |
| `PGID`        | Group ID for file permissions (default: `1000`)                                         |

### FileBrowser

| Variable      | Description                               |
| ------------- | ----------------------------------------- |
| `FB_PORT`     | FileBrowser port (default: `8080`)        |
| `FB_USERNAME` | Initial admin username (default: `admin`) |
| `FB_PASSWORD` | Initial admin password (default: `admin`) |

### API Keys

| Variable               | Description                       |
| ---------------------- | --------------------------------- |
| `ANTHROPIC_API_KEY`    | Anthropic API key                 |
| `OPENAI_API_KEY`       | OpenAI API key                    |
| `GEMINI_API_KEY`       | Google Gemini API key             |
| `COPILOT_GITHUB_TOKEN` | GitHub token (for GitHub Copilot) |
| `OPENROUTER_API_KEY`   | OpenRouter API key                |
| `XAI_API_KEY`          | xAI API key                       |
| `BRAVE_API_KEY`        | Brave Search API key              |

## Quick Start

1. Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

2. (Optional) Install dev-tools volume:

```bash
docker compose -f dev-tools/docker-compose.yml up -d --build
```

3. Start all services:

```bash
docker compose up -d --build
```

4. Access services:
   - **FileBrowser**: http://localhost:$FB_PORT (default: http://localhost:8080)
   - **OpenClaw**: via Tailscale network (required for VPN access)
