#!/bin/bash
set -euo pipefail

# TODO: if no tmux, popup message
# TODO: if no fzf, popup message

# Breakdown
# `[ ... ]`: test command, works as if statement
# `-n`: return true for truthy, false for falsy
tmux display-popup -w 75% -h 75% -E \
  'session=$(tmux list-sessions -F "#{session_name}" | fzf ) \
   && [ -n "$session" ] \
   && tmux switch-client -t "$session" || [ $? -eq 130 ]'
