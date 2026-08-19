
#eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(direnv hook zsh)"

alias l="ls -aFG"
alias h="history 10"
alias dotfiles='git --git-dir=$HOME/.dotfilesgit --work-tree=$HOME'
alias makemkvcon="/Applications/MakeMKV.app/Contents/MacOS/makemkvcon"
#alias 'srv=/Users/drr/ws/e4-smaller-module-sample/node_modules/http-server/bin/http-server -c-1'

setopt ignore_eof

HISTSIZE=10000

function cd() {
  builtin cd "$@"
  if [[ -f .zsh_aliases ]]; then
    source .zsh_aliases
  fi
}

#PROMPT='%n@%m %1~ %# '
#PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
PROMPT='%F{blue}%~%f$ '
# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
