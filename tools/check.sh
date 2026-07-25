#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
WEB_ROOT="$REPO_ROOT/web"
mode="${1:-}"

if [[ -n "$mode" && "$mode" != "--full" ]]; then
    echo "Usage: tools/check.sh [--full]" >&2
    exit 2
fi

if [[ ! -d "$WEB_ROOT/node_modules" ]]; then
    echo "Web dependencies are missing. Run: npm --prefix web ci" >&2
    exit 1
fi

"$SCRIPT_DIR/validate.sh"

if [[ "$mode" == "--full" ]]; then
    npm --prefix "$WEB_ROOT" run check:full
else
    npm --prefix "$WEB_ROOT" run check
fi
