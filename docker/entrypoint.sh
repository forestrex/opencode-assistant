#!/bin/bash
set -e

CONFIG_DIR="/root/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/opencode.json"

mkdir -p "$CONFIG_DIR"

SKIP_CONFIG_CHECK=false
if [[ "$1" == "auth" ]] || [[ "$1" == "help" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  SKIP_CONFIG_CHECK=true
fi

if [ "$SKIP_CONFIG_CHECK" = false ] && [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️  OpenCode Environment not initialized. Please run the following command first:"
  echo "   docker run -it --rm -v \$HOME/.config/opencode:/root/.config/opencode opencode-cli auth login"
  echo ""
  echo "💡 Hint: Make sure the configuration volume (-v \$HOME/.config/opencode:/root/.config/opencode) is mounted."
  exit 1
fi
    
if [[ "$1" == "openspec" ]]; then
    shift
    exec openspec "$@"
elif [[ "$1" == "specify" ]]; then
    shift
    exec specify "$@"
else
    exec opencode "$@"
fi
