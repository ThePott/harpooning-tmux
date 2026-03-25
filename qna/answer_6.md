# Answer: Core Logic of ThePrimeagen's tmux-sessionizer

## How does tmux-sessionizer search directories so fast?

The key insight is that **tmux-sessionizer does NOT search the entire PC**. It uses a **constrained search** with two
critical optimizations:

### 1. Limited Search Paths (TS_SEARCH_PATHS)

```bash
# Default search paths - only specific directories, NOT the entire filesystem
[[ -n "$TS_SEARCH_PATHS" ]] || TS_SEARCH_PATHS=(~/ ~/personal ~/personal/dev/env/.config)
```

Users can configure specific directories to search:

```bash
# Config file: ~/.config/tmux-sessionizer/tmux-sessionizer.conf
TS_SEARCH_PATHS=(~/)
TS_EXTRA_SEARCH_PATHS=(~/ghq:3 ~/Git:3 ~/.config:2)
```

### 2. Shallow Depth (maxdepth)

```bash
# Default max depth is only 1 level!
find "$path" -mindepth 1 -maxdepth "${depth:-${TS_MAX_DEPTH:-1}}" ...
```

- Default `TS_MAX_DEPTH=1` means it only looks 1 level deep
- Users can specify depth per-path with `:N` suffix (e.g., `~/Git:3` searches 3 levels deep)

## Where is the code for searching .git containing folders?

The core search logic is in the `find_dirs()` function (lines ~213-234 in the source):

```bash
find_dirs() {
    # List existing TMUX sessions first
    if [[ -n "${TMUX}" ]]; then
        current_session=$(tmux display-message -p '#S')
        tmux list-sessions -F "[TMUX] #{session_name}" 2>/dev/null | grep -vFx "[TMUX] $current_session"
    else
        tmux list-sessions -F "[TMUX] #{session_name}" 2>/dev/null
    fi

    # Search configured paths
    for entry in "${TS_SEARCH_PATHS[@]}"; do
        # Parse optional depth suffix (path:depth format)
        if [[ "$entry" =~ ^([^:]+):([0-9]+)$ ]]; then
            path="${BASH_REMATCH[1]}"
            depth="${BASH_REMATCH[2]}"
        else
            path="$entry"
        fi

        # The actual find command
        [[ -d "$path" ]] && find "$path" -mindepth 1 -maxdepth "${depth:-${TS_MAX_DEPTH:-1}}" \
            -path '*/.git' -prune -o -type d -print
    done
}
```

### Key find command breakdown:

```bash
find "$path" -mindepth 1 -maxdepth "${depth:-${TS_MAX_DEPTH:-1}}" -path '*/.git' -prune -o -type d -print
```

| Part                    | Purpose                                                  |
| ----------------------- | -------------------------------------------------------- |
| `-mindepth 1`           | Skip the root directory itself                           |
| `-maxdepth N`           | Limit search depth (default: 1)                          |
| `-path '*/.git' -prune` | **Skip descending into .git directories** (optimization) |
| `-o -type d -print`     | Print all other directories                              |

**Important Note**: This command does **NOT filter for directories containing `.git`**. It actually:

1. Lists **all directories** within the search paths
2. Uses `-path '*/.git' -prune` to **skip the contents of .git folders** (for performance, not filtering)

## Summary: Why It's Fast

1. **Not searching entire PC** - Only searches user-configured directories
2. **Shallow depth** - Default depth of 1-3 levels, not recursive
3. **Prunes .git internals** - Skips scanning inside .git directories
4. **Piped to fzf** - Results stream directly to fzf for interactive filtering

The speed comes from **not doing what you assumed** - it doesn't scan the whole filesystem looking for .git folders.
Instead, users configure specific project directories (like `~/projects`, `~/work`) and it lists immediate
subdirectories.
