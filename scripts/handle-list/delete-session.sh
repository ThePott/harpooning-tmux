#!/bin/bash
set -euo pipefail

SESSION="$1"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"

if grep -qx "^- \[ \] $SESSION$" "$HARPOON_LIST"; then # Check if checked version exists
    sed -i '' '/^- \[ \] '"$SESSION"'$/d' "$HARPOON_LIST"
fi
