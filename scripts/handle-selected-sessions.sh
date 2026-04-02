#!/bin/bash
set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# NOTE: '' - just string. literal string << NOT highlight keywords 
# NOTE: "" - can include variable << highlight keywords
tmux display-popup -w 50% -h 50% -E "cd $CURRENT_DIR && vim ./harpoon-list.md" 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"
CHECKED_SESSIONS=$(grep -E '^- \[x\]' "$HARPOON_LIST" | sed 's/^- \[x\] //')
COUNT=$(echo "$CHECKED_SESSIONS" | grep -c .)


if [ $COUNT -eq 0 ]; then
    FIRST_SESSION=$(sed -n "1p" "$HARPOON_LIST" | "sed s/^- \[.*] /")
    tmux switch-client -t "$SESSION_NAME"
else
    FIRST_CHECKED_SESSION=$(grep -E '^- \[x\]' "$HARPOON_LIST" | sed 's/^- \[x\] //')
    tmux switch-client -t "$CHECKED_SESSIONS"
    if [ $COUNT -gt 1 ]; then
        sed -i '' '%s/^- \[.*\]/- [ ]' "$HARPOON_LIST"
        if grep -qxF "- [ ] $FIRST_CHECKED_SESSION" "$HARPOON_LIST"; then # Check if checked version exists
            sed -i '' "s/- [ ] $FIRST_CHECKED_SESSION/- [x] $FIRST_CHECKED_SESSION/" "$HARPOON_LIST"
        fi
    fi
fi
