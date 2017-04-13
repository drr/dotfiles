# drr ~/.bashrc

alias l="ls -aFG"
alias h="history 10"
alias dotfiles='git --git-dir=$HOME/.dotfilesgit --work-tree=$HOME'

HISTSIZE=5000
IGNOREEOF=

if [ -r ~/gows/bin ]; then
	export GOPATH=~/gows
	PATH=$PATH:$GOPATH/bin
fi

if [ -z "$SSH_CLIENT" ]; then
	PS1='\[\033[34m\]\! \W\$\[\033[0m\] '
else
	PS1='\[\033[34m\]\! \u@\h:\W\$\[\033[0m\] '
fi
