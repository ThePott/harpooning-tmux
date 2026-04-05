#!/bin/bash
set -euo pipefail

tmux display-popup -w 75% -h 75% -E '
    TEMP_FILE="/tmp/harpooning-session.txt"
    SESSION=$(tmux list-sessions -F "#{session_name}" | fzf); \
    echo "$SESSION" > "$TEMP_FILE"
'

TEMP_FILE="/tmp/harpooning-session.txt"
SESSION=$(sed -n "1p" "$TEMP_FILE")
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
