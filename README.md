# Too many tmux sessions? Worry not, simply harpoon them.

`harpooning-tmux` is re-invention of ThePrimeagen's Harpoon for tmux. You can select a few sessions and order as your
taste, navigate them with key binds.

## What it does

- Search: You can fuzzy find all sessions with fzf
- Store: You can select certain session to `harpoon-list.txt`
- Navigate: You can move to n-th session from `harpoon-list.txt` with key bind

## Why new harpoon for tmux when `tmux-sessionizer` exists?

- `tmux-sessionizer` is mainly for creating new session after fuzzy finding projects
- hapoon-like navigation is also possible, but it is done by vim-script, which cannot be executed outside of vim
- Instead, I want to open sessions that I want to keep I on, but focus on small amount of it at a time

## Installation

### Pre-requisite

- tmux
- vim
- tpm(tmux package manager)

### Install with tpm

1. add this to `~/.tmux.conf`

```tmux

```

2. press `prefix + I` to install package

## Key Binds

- prefix + hs: fuzzy find sessions
- prefix + ho: show harpooning-list
-

## Limitation

- Unlike real harpoon, navigating by pressing enter at harpooning-list is not available. `harpooning-list` is only for
  setting orders of key-bind navigation
