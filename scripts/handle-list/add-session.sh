#!/bin/bash
set -euo pipefail

SESSION="$1"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"


if grep -qx "^- \[.*\] $SESSION$" "$HARPOON_LIST"; then # Check if checked version exists
    tmux switch-client -t "$SESSION"
else
    echo "- [ ] $SESSION" >> "$HARPOON_LIST"
fi


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CHECK_SESSION="$CURRENT_DIR/check-session.sh"
bash "$CHECK_SESSION" "$SESSION"
