# Answer: Closing popup and switching to selected session

## Problem 1: Floating window stays open

You're using `-echo` but the correct flag is `-E`.

| Flag | Meaning                                   |
| ---- | ----------------------------------------- |
| `-E` | Close popup when command **E**xits        |
| `-e` | Close popup only on success (exit code 0) |

## Problem 2: Can't pass session name outside

This won't work:

```bash
session=$(...)
tmux display-popup ... "session=$(...)"
```

**Why?** The popup runs in a **separate shell process**. Variables set inside cannot be accessed outside. It's like two
different programs.

## Solution: Do everything inside the popup

Don't try to pass the value out. Run the switch command **inside** the popup:

```bash
tmux display-popup -w 75% -h 75% -E \
  'session=$(tmux list-sessions -F "#{session_name}" | fzf) && [ -n "$session" ] && tmux switch-client -t "$session"'
```

### How it works

1. `tmux display-popup -E` - Opens popup, closes when command exits
2. Inside the popup:
    - `session=$(... | fzf)` - User selects a session
    - `&& [ -n "$session" ]` - If selection is not empty...
    - `&& tmux switch-client -t "$session"` - Switch to that session

### Alternative: Using xargs (shorter)

```bash
tmux display-popup -w 75% -h 75% -E \
  "tmux list-sessions -F '#{session_name}' | fzf | xargs -r tmux switch-client -t"
```

The `-r` flag tells xargs to not run if input is empty (when user presses ESC).

## Your updated `scripts/index.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

tmux display-popup -w 75% -h 75% -E \
  'session=$(tmux list-sessions -F "#{session_name}" | fzf --prompt="Switch to: ") && [ -n "$session" ] && tmux switch-client -t "$session"'
```

## Summary

| Your code                | Problem            | Fix                         |
| ------------------------ | ------------------ | --------------------------- |
| `-echo`                  | Invalid flag       | Use `-E`                    |
| Capture variable outside | Subshell isolation | Run everything inside popup |
