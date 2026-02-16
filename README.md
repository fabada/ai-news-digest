# AI News Digest

An automated pipeline that uses Claude to search the web for the latest AI news and delivers a formatted summary to your inbox.

## How it works

1. **Fetch** — Runs Claude (via the CLI) with web search to find the top AI news from the past 2 days across models, research, industry, policy, and open source.
2. **Validate** — Extracts structured JSON from Claude's response and checks that news items were found.
3. **Send** — Pipes the JSON into a Go binary that renders HTML + plain-text emails and sends them via SMTP.

## Setup

### Prerequisites

- [Claude CLI](https://docs.anthropic.com/en/docs/claude-code) (`claude` on your PATH)
- Go 1.25+
- A Gmail account with an [App Password](https://myaccount.google.com/apppasswords) (or another SMTP provider)
- `jq`

### Install

```bash
# Clone the repo
git clone https://github.com/fabada/ai-news-digest.git
cd ai-news-digest

# Build the email sender
go build -o send-email ./cmd/send-email/

# Create config
cp config.env.example config.env
# Edit config.env with your SMTP credentials

# Create logs directory
mkdir -p logs
```

### Configuration

Edit `config.env` with your SMTP details:

```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=you@gmail.com
SMTP_PASSWORD=xxxx-xxxx-xxxx-xxxx
FROM_EMAIL=you@gmail.com
TO_EMAIL=you@gmail.com
```

For Gmail, generate an App Password under Google Account > Security > App Passwords.

## Usage

### Manual run

```bash
./run.sh
```

### Scheduled (macOS)

A LaunchAgent plist is included to run the digest every Saturday at 8am:

```bash
# Edit the plist to replace the run.sh path with your local filepath
cp com.fabada.ai-news-digest.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.fabada.ai-news-digest.plist
```

To stop it:

```bash
launchctl unload ~/Library/LaunchAgents/com.fabada.ai-news-digest.plist
```

## Project structure

```
run.sh                          # Main pipeline script
prompt.md                       # Claude prompt for news search
schema.json                     # JSON schema for Claude's output
config.env                      # SMTP credentials (gitignored)
config.env.example              # Example config
cmd/send-email/main.go          # Go email sender
com.fabada.ai-news-digest.plist # macOS LaunchAgent
logs/                           # Run logs (gitignored)
```
