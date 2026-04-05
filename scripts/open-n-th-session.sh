#!/bin/bash
set -euo pipefail

LINE_NUM="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"

SESSION=$(sed -n "$((LINE_NUM + 1))p" "$HARPOON_LIST" | sed 's/^- \[.*] //')

if tmux has-session -t="$SESSION" 2>/dev/null; then
    tmux switch-client -t "$SESSION"
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ADD_SESSION="$SCRIPT_DIR/handle-list/add-session.sh"
if [ -n "$SESSION" ]; then \
    bash "$ADD_SESSION" "$SESSION"; \
else
    echo "no session"
fi
