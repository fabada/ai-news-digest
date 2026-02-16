#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Logging
LOGFILE="logs/run-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "=== AI News Digest run started at $(date) ==="

# Rotate logs: keep last 30
ls -1t logs/run-*.log 2>/dev/null | tail -n +31 | xargs rm -f 2>/dev/null || true

# Load config
source "$SCRIPT_DIR/config.env"

# Stage 1: Fetch news via Claude
echo "Stage 1: Fetching AI news with Claude..."
SCHEMA=$(cat "$SCRIPT_DIR/schema.json")
TODAY=$(date +%Y-%m-%d)
WEEK_AGO=$(date -v-7d +%Y-%m-%d)
PROMPT=$(sed -e "s/{{TODAY}}/$TODAY/g" -e "s/{{WEEK_AGO}}/$WEEK_AGO/g" "$SCRIPT_DIR/prompt.md")
CLAUDE_RAW=$(echo "$PROMPT" | claude -p \
  --allowedTools WebSearch \
  --output-format json \
  --json-schema "$SCHEMA" \
  --max-budget-usd 0.50 \
  --max-turns 10 \
  --model sonnet)

# Stage 2: Extract result and validate
echo "Stage 2: Extracting and validating..."
NEWS_JSON=$(echo "$CLAUDE_RAW" | jq -c '.structured_output // .result')

ITEM_COUNT=$(echo "$NEWS_JSON" | jq -r '.item_count')
if [ "$ITEM_COUNT" -eq 0 ] 2>/dev/null; then
  echo "No news items found. Skipping email."
  exit 0
fi

echo "Found $ITEM_COUNT news items."

# Stage 3: Send email
echo "Stage 3: Sending email..."
echo "$NEWS_JSON" | "$SCRIPT_DIR/send-email" \
  --smtp-host "$SMTP_HOST" \
  --smtp-port "$SMTP_PORT" \
  --smtp-user "$SMTP_USER" \
  --smtp-password "$SMTP_PASSWORD" \
  --from "$FROM_EMAIL" \
  --to "$TO_EMAIL"

echo "=== Run completed at $(date) ==="
