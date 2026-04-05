#!/bin/bash
set -euo pipefail

# NOTE: '' - just string. literal string << NOT highlight keywords 
# NOTE: "" - can include variable << highlight keywords
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux display-popup -w 50% -h 50% -E "cd $CURRENT_DIR && vim ./harpoon-list.md" 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.md"

LOG_FILE="/tmp/harpooning.log"
echo "new logs" > "$LOG_FILE"

SESSION=$(grep -E '^- \[x\]' "$HARPOON_LIST" | sed 's/^- \[x\] //' || true)
if [ -z "$SESSION" ]; then
    echo "no x" >> "$LOG_FILE"
    SESSION=$(grep -E '^- \[o\]' "$HARPOON_LIST" | sed 's/^- \[o\] //' || true)
fi
if [ -z "$SESSION" ]; then
    echo "no o" >> "$LOG_FILE"
    SESSION=$(sed -n "1p" "$HARPOON_LIST" | "sed s/^- \[.*] /")
fi
echo "final session: $SESSION" >> "$LOG_FILE"

ADD_SESSION="$SCRIPT_DIR/handle-list/add-session.sh"
DELETE_SESSION="$SCRIPT_DIR/handle-list/delete-session.sh"

tmux switch-client -t "$SESSION"
bash "$ADD_SESSION" "$SESSION"

# sync list and actual sessions
LIST_SESSIONS=$(sed 's/^- \[.\] //' "$HARPOON_LIST")
ACTUAL_SESSIONS=$(tmux list-sessions -F "#{session_name}")

while IFS= read -r session; do
    if ! echo "$ACTUAL_SESSIONS" | grep -qx "$session"; then
        # Session in list but not in tmux - remove from list
        sed -i '' "/^- \[.\] $session$/d" "$HARPOON_LIST"
    fi
done <<< "$LIST_SESSIONS"
while IFS= read -r session; do
    if ! echo "$LIST_SESSIONS" | grep -qx "$session"; then
        # Session in tmux but not in list - kill it
        tmux kill-session -t "$session"
    fi
done <<< "$ACTUAL_SESSIONS"
