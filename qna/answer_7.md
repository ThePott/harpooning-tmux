# Answer: MVP for Git Directory Finder

## MVP Implementation

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Hardcoded search paths with depths (path:depth)
SEARCH_PATHS=(
    "$HOME/:1"
    "$HOME/Desktop/SRC/:4"
)

# 2. Find directories containing .git as direct child
find_git_dirs() {
    for entry in "${SEARCH_PATHS[@]}"; do
        path="${entry%:*}"
        depth="${entry#*:}"

        [[ -d "$path" ]] || continue

        find "$path" -mindepth 1 -maxdepth "$depth" -type d -name ".git" 2>/dev/null | sed 's|/\.git$||'
    done
}

# 3. Show with fzf and switch session
selected=$(find_git_dirs | sort -u | fzf --prompt="Git project: ")

[[ -n "$selected" ]] || exit 0

# Create/switch tmux session
session_name=$(basename "$selected" | tr . _)
if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi
tmux switch-client -t "$session_name"
```

## Key Components

| Component          | Implementation                                            |
| ------------------ | --------------------------------------------------------- |
| Search config      | Hardcoded array `SEARCH_PATHS=("path:depth" ...)`         |
| Find .git dirs     | `find ... -type d -name ".git"` then strip `/.git` suffix |
| Interactive select | Pipe to `fzf`                                             |
| Session switch     | Standard tmux `new-session` + `switch-client`             |

## Why This Approach

1. **Direct .git search**: Using `-name ".git" -type d` directly finds `.git` folders, then `sed 's|/\.git$||'` gets
   parent directory

2. **Simple config**: Array with `path:depth` format, easy to modify

3. **No dependencies**: Only requires `bash`, `find`, `fzf`, `tmux`

## Minimal One-Liner Version (for testing)

```bash
find ~/ ~/Desktop/SRC -maxdepth 4 -type d -name ".git" 2>/dev/null | sed 's|/\.git$||' | fzf
```
