#!/bin/bash
set -e

CONFIG_DIR="/root/.opencode"
CONFIG_FILE="$CONFIG_DIR/config.json"

mkdir -p "$CONFIG_DIR"

SKIP_CONFIG_CHECK=false
if [[ "$1" == "auth" ]] || [[ "$1" == "help" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  SKIP_CONFIG_CHECK=true
fi

if [ "$SKIP_CONFIG_CHECK" = false ] && [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️  OpenCode Environment not initialized. Please run the following command first:"
  echo "   docker run -it --rm -v \$HOME/.opencode:/root/.opencode opencode-cli auth login"
  echo ""
  echo "💡 Hint: Make sure the configuration volume (-v \$HOME/.opencode:/root/.opencode) is mounted."
  exit 1
fi

if [ "$SKIP_CONFIG_CHECK" = false ] && [ -f "$CONFIG_FILE" ]; then
  if command -v jq >/dev/null 2>&1; then
    if ! grep -q '"contextProvider"' "$CONFIG_FILE" 2>/dev/null || \
       ! grep -q '"contextProvider": "mgrep"' "$CONFIG_FILE" 2>/dev/null; then
      echo "🔧 Start to configurate mgrep for context provider..."
      jq '.contextProvider = "mgrep"' "$CONFIG_FILE" > /tmp/config.tmp && mv /tmp/config.tmp "$CONFIG_FILE"
    fi
  else
    echo "⚠️  jq not found, failed to configurate mgrep。"
  fi
fi

exec opencode "$@"
