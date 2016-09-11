# dotfiles
Experimenting with https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

First clean out any remnant dotfiles (failing to do so will cause the `git checkout` to fail), then:

```sh
alias dotfiles='git --git-dir=$HOME/.dotfilesgit --work-tree=$HOME'
git clone --bare https://github.com/drr/dotfiles.git .dotfilesgit
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no #optional
```
