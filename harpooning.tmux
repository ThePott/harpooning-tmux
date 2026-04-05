#!/bin/bash
set -euo pipefail

# Get the current directory of the plugin
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# First key enters a custom table
tmux bind-key -T prefix h switch-client -T harpooning
# Second key in that table runs your script
tmux bind-key -T harpooning o run-shell "bash $CURRENT_DIR/scripts/handle-selected-sessions.sh"
tmux bind-key -T harpooning s run-shell "bash $CURRENT_DIR/scripts/fzf-sessions.sh"
tmux bind-key -T harpooning a display-popup -w 75% -h 75% -E "bash $CURRENT_DIR/scripts/fzf-then-attach.sh"

for i in {0..9}; do
    tmux bind-key -T harpooning "$i" run-shell "bash $CURRENT_DIR/scripts/open-n-th-session.sh $i"
done


