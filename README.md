# dotfiles
Experimenting with https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

First clean out any remnant dotfiles (failing to do so will cause the `git checkout` to fail), then:

```sh
alias dotfiles='git --git-dir=$HOME/.dotfilesgit --work-tree=$HOME'
git clone --bare https://github.com/drr/dotfiles.git .dotfilesgit
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no #optional
```

## New machine setup

The dotfiles assume Homebrew at `/opt/homebrew`. Then:

```sh
brew install neovim node nvm uv # vi/vim/$EDITOR are nvim; the shell's node is Homebrew's
brew install glow fzf           # optional: :MarkdownPreview and <C-p> in Neovim
nvm alias default system        # in a new shell (nvm is lazy-loaded); keeps nvm off PATH
uv python install 3.14 --default  # the shell's python3/python, in ~/.local/bin
```

Node: interactive `node`/`npm`/`npx` come from Homebrew and stay patched with `brew upgrade`. nvm only stores
the exact versions projects pin (`.nvmrc`); their Makefiles run them by absolute path, so install each with
`nvm install <version>` when setting up a project. Without the `system` default, the first `nvm` call in a shell
would put nvm's default node ahead of Homebrew's.

Python: everything goes through uv. `python3`/`python` in the shell are uv's 3.14 (`.zprofile` puts `~/.local/bin`
ahead of Apple's end-of-life `/usr/bin/python3`, which Xcode keeps). Projects pin a minor line in `.python-version`
and get their interpreter from uv; `uv python upgrade` installs new patch releases for the shell and every project.
`~/.config/uv/uv.toml` sets a 14-day cooldown on new PyPI uploads, with commented exceptions for urgent fixes.

rbenv and direnv are optional: their hooks run only if they're installed.
