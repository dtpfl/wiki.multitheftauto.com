#!/usr/bin/env bash

set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
VALIDATOR="$SCRIPT_DIR/yajsv"
COMMON_SCHEMA="$REPO_ROOT/schemas/common-defs.yaml"
validation_failed=0

if [[ ! -x "$VALIDATOR" ]]; then
    echo "Validator is not executable: $VALIDATOR" >&2
    echo "Run: chmod +x tools/yajsv tools/validate.sh" >&2
    exit 1
fi

validate_collection() {
    local label="$1"
    local directory="$2"
    local schema="$3"
    local status
    local -a documents=()

    mapfile -d '' documents < <(find "$directory" -type f -name '*.yaml' -print0 | sort -z)

    if (( ${#documents[@]} == 0 )); then
        echo "No YAML documents found for $label in $directory" >&2
        validation_failed=1
        return
    fi

    printf 'Validating %s (%d documents)...\n' "$label" "${#documents[@]}"
    "$VALIDATOR" -q -s "$schema" -r "$COMMON_SCHEMA" "${documents[@]}"
    status=$?

    if (( status != 0 )); then
        validation_failed=1
    fi
}

validate_collection "functions" "$REPO_ROOT/functions" "$REPO_ROOT/schemas/function.yaml"
validate_collection "elements" "$REPO_ROOT/elements" "$REPO_ROOT/schemas/element.yaml"
validate_collection "events" "$REPO_ROOT/events" "$REPO_ROOT/schemas/event.yaml"

if (( validation_failed != 0 )); then
    echo "YAML validation failed." >&2
    exit 1
fi

echo "YAML validation passed."
