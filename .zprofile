
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by `rbenv init` on Tue Apr  8 21:24:36 PDT 2025
if type rbenv &>/dev/null; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# Personal scripts, ahead of Homebrew and system dirs. `typeset -U` keeps
# PATH free of duplicates when a login shell is nested.
# ~/.local/bin (the standard per-user bin) holds uv's python3/python
# (`uv python install 3.14 --default`; patched by `uv python upgrade`) and
# `uv tool install` commands, ahead of Apple's end-of-life /usr/bin/python3.
typeset -U path
path=(~/bin ~/.local/bin $path)
