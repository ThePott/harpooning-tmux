#!/bin/bash
set -euo pipefail

LINE_NUM="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"

SESSION_NAME=$(sed -n "$((LINE_NUM + 1))p" "$HARPOON_LIST" | "sed s/^- \[.*] /")

# handle session
if [ -n "$SESSION_NAME" ];
then tmux switch-client -t "$SESSION_NAME"
else tmux display-message "No session at slot $LINE_NUM"
fi

# NOTE: clear all checks
sed -i '' '%s/^- \[.*\]/- [ ]' "$HARPOON_LIST"
if grep -qxF "- [ ] $SESSION" "$HARPOON_LIST"; then # Check if checked version exists
    sed -i '' "s/- [ ] $SESSION/- [x] $SESSION/" "$HARPOON_LIST"
fi

