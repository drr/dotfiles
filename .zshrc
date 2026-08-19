
eval "$(direnv hook zsh)"

alias l="ls -aFG"
alias h="history 10"
alias dotfiles='git --git-dir=$HOME/.dotfilesgit --work-tree=$HOME'
alias makemkvcon="/Applications/MakeMKV.app/Contents/MacOS/makemkvcon"

setopt ignore_eof

function cd() {
  builtin cd "$@"
  if [[ -f .zsh_aliases ]]; then
    source .zsh_aliases
  fi
}

# --- History --------------------------------------------------------------
# Keep a lot of it, and write every command to disk the instant it's run
# (durable across a closed tab / crash / reboot). Each tab's own recall
# stays scoped to that tab, though — no live cross-tab interleaving.
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY        # record a timestamp for each command
setopt INC_APPEND_HISTORY      # write each command as it's entered, not just at exit
#setopt SHARE_HISTORY          # would also live-import other sessions' new commands
setopt HIST_IGNORE_DUPS        # skip recording a line identical to the previous one
setopt HIST_IGNORE_ALL_DUPS    # drop the older copy when a duplicate is added
setopt HIST_REDUCE_BLANKS      # trim extra whitespace before saving
setopt HIST_VERIFY             # show a !-expanded command before running it

# --- Completion -------------------------------------------------------------
# Activates the zsh completions that Homebrew formulae ship (git, gh, brew
# subcommands, etc.) by adding their directory to fpath before compinit.
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- Editor / vi -------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
alias vi=nvim
alias vim=nvim

# --- Prompt -------------------------------------------------------------
# Short, git-aware, and portable: built entirely from zsh's own vcs_info,
# so copying this file to any machine with zsh gets the identical prompt,
# no extra installs required.
autoload -Uz vcs_info
setopt PROMPT_SUBST

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{green}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}(%b|%a%u%c)%f'

precmd() { vcs_info }

# User/host segment: blank on a normal local session as `drr`. Shows
# "user@host" in red if logged in as anyone else (su/sudo -s spawn a new
# shell, so this only needs to be computed once, not on every prompt).
# Shows just the hostname if connected over SSH, even while still `drr`.
if [[ "$(id -un)" != "drr" ]]; then
  _prompt_userhost='%F{red}%n@%m%f '
elif [[ -n "$SSH_CONNECTION" ]]; then
  _prompt_userhost='%F{red}%m%f '
else
  _prompt_userhost=''
fi

PROMPT='${_prompt_userhost}%S %2~ %s${vcs_info_msg_0_} %(!.%B%F{red}#%f%b.%#) '

# NVM (Node Version Manager) — lazy-loaded. Sourcing nvm.sh eagerly on every
# shell startup costs ~300ms per new tab; these stubs defer that cost to the
# first time node/npm/npx/nvm is actually run in a given shell.
export NVM_DIR="$HOME/.nvm"
_nvm_lazy_load() {
  unset -f nvm node npm npx
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}
nvm()  { _nvm_lazy_load; nvm "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm()  { _nvm_lazy_load; npm "$@"; }
npx()  { _nvm_lazy_load; npx "$@"; }

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

