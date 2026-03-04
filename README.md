# openclaw

OpenClaw gateway with FileBrowser and Tailscale for internal access.

## Services

| Service       | Description                               |
| ------------- | ----------------------------------------- |
| `openclaw`    | OpenClaw gateway                          |
| `filebrowser` | Web-based file browser                    |
| `tailscale`   | Mesh VPN for internal access              |
| `dev-tools`   | Dev tools via mise, mounted into openclaw |

## Environment Variables

| Variable                 | Description                                                                             |
| ------------------------ | --------------------------------------------------------------------------------------- |
| `TS_AUTHKEY`             | Auth key from [Tailscale admin → Keys](https://login.tailscale.com/admin/settings/keys) |
| `TS_HOSTNAME`            | Node name that will appear in your Tailscale admin panel                                |
| `FB_PORT`                | FileBrowser port (default: `8080`)                                                      |
| `GITHUB_TOKEN`           | GitHub token for dev-tools installation                                                 |
| `OPENCLAW_GATEWAY_TOKEN` | Gateway token — generate via onboarding (see below)                                     |
| `ANTHROPIC_API_KEY`      | Anthropic API key                                                                       |
| `BRAVE_API_KEY`          | Brave Search API key                                                                    |

## Usage

1. Copy `.env.example` to `.env` and fill in your values
2. Generate the gateway token:

```bash
docker compose run --rm openclaw onboard
```

3. Copy the generated token to `OPENCLAW_GATEWAY_TOKEN` in `.env`
4. Start all services:

```bash
docker compose up -d
```
