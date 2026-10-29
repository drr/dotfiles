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
brew install neovim node nvm    # vi/vim/$EDITOR are nvim; the shell's node is Homebrew's
brew install glow fzf           # optional: :MarkdownPreview and <C-p> in Neovim
nvm alias default system        # in a new shell (nvm is lazy-loaded); keeps nvm off PATH
```

Node: interactive `node`/`npm`/`npx` come from Homebrew and stay patched with `brew upgrade`. nvm only stores
the exact versions projects pin (`.nvmrc`); their Makefiles run them by absolute path, so install each with
`nvm install <version>` when setting up a project. Without the `system` default, the first `nvm` call in a shell
would put nvm's default node ahead of Homebrew's.

rbenv and direnv are optional: their hooks run only if they're installed.
