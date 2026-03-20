# Answer: Dynamic keybindings for each line in the list

## Best Solution: Dynamic lookup at keypress time (Recommended)

Instead of rebinding keys every time the list changes, create a single script that looks up the session dynamically when you press the key.

### Step 1: Create `scripts/goto-session.sh`

```bash
#!/bin/bash
set -euo pipefail

LINE_NUM="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HARPOON_LIST="$SCRIPT_DIR/harpoon-list.txt"

# Get the n-th line (sed is 1-indexed, so LINE_NUM+1)
SESSION_NAME=$(sed -n "$((LINE_NUM + 1))p" "$HARPOON_LIST")

if [ -n "$SESSION_NAME" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux display-message "No session at slot $LINE_NUM"
fi
```

### Step 2: Bind keys 0-9 in `harpooning.tmux`

```bash
# Bind number keys to goto-session script with line number as argument
for i in {0..9}; do
    tmux bind-key -T harpooning "$i" run-shell "bash $CURRENT_DIR/scripts/goto-session.sh $i"
done
```

### How it works

1. `prefix h 0` runs `goto-session.sh 0`
2. Inside the script, `$1` equals `"0"` (first argument)
3. `sed -n "1p"` reads line 1 (first line) from harpoon-list.txt
4. Script switches to that session

### What is `$1`?

Arguments passed to a script are accessed via `$1`, `$2`, `$3`, etc:

```bash
bash myscript.sh apple banana
# $1 = "apple"
# $2 = "banana"
```

## Why this approach is better

| Static binding (unbind/rebind) | Dynamic lookup (this approach) |
|-------------------------------|-------------------------------|
| Must re-source after editing list | Works immediately after editing |
| Bindings can get stale | Always reads current file |
| More complex setup code | Simple, single script |

This is how the original harpoon.nvim works too.

---

## Alternative: Static bindings (not recommended)

If you prefer static bindings that are set at startup:

```bash
HARPOON_LIST="$CURRENT_DIR/scripts/harpoon-list.txt"

# Unbind old number keys first (0-9)
for i in {0..9}; do
    tmux unbind-key -T harpooning "$i" 2>/dev/null || true
done

# Bind each line to a number key
if [ -f "$HARPOON_LIST" ]; then
    line_num=0
    while IFS= read -r session_name || [ -n "$session_name" ]; do
        if [ -n "$session_name" ]; then
            tmux bind-key -T harpooning "$line_num" switch-client -t "$session_name"
            ((line_num++))
        fi
        [ "$line_num" -ge 10 ] && break
    done < "$HARPOON_LIST"
fi
```

Downside: You must run `tmux source-file ~/.tmux.conf` every time you edit the list.
