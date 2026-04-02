#!/bin/bash
set -euo pipefail


# Breakdown
# `[ ... ]`: test command, works as if statement
# `-n`: return true for truthy, false for falsy
tmux display-popup -w 75% -h 75% -E 'PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; \
ADD_SESSION="$PWD/scripts/handle-list/add-session.sh"; \

SESSION=$(tmux list-sessions -F "#{session_name}" | fzf); \
if [ -n "$SESSION" ]; then \
    bash "$ADD_SESSION" "$SESSION"; \
else
    echo "no session"
fi'
