# My Goal: move to selected session from fzf

## Current status: show all session and search with fzf

- keymap -> open floating window showing session list -> search session -> enter -> show matching session name

## Problem

### the floating window is keep open

- I want to close the window when fzf ends

### I do not know how to pass selected session name outside of the command

#### current code

```bash
tmux display-popup -w 75% -h 75% -echo "tmux list-sessions -F '#{session_name}' | fzf"
```

#### tried

```bash
# make session global
session=$(null)
# store session at inside of tmux command
tmux display-popup -w 75% -h 75% -echo "session=$(tmux list-sessions -F '#{session_name}' | fzf)"
```
