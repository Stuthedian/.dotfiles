alias g='gedit'
alias mtargz='tar -xzf'
alias mtarbz='tar -xjf'
alias tips='vim /media/hdd/home/default/Docs/tips /media/hdd/home/default/Docs/key_combinations /media/hdd/home/default/Docs/todo /media/hdd/home/default/Docs/configs'
alias :q='exit'
alias llg='ls -lt | head -6 | tail -5'
alias unz='tar -x -I zstd -f'

#Git
alias gst='git status'
alias gstt='git status --untracked-files=no'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias gh='git log --perl-regexp --author="Асиф Талыбов|Stuthedian"\
  --pretty=format:"%h %ad | %s%d [%an]" --graph --date=format:"%d.%m.%Y"'
alias gha='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=format:"%d.%m.%Y"'
alias gco='git checkout'
alias gci='git commit -m'
alias gbr='git branch'
alias gad='git add'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'

#Git dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias dst='dotfiles status'
alias ddf='dotfiles diff'
alias ddfc='dotfiles diff --cached'
alias dh='dotfiles log --perl-regexp --author="Асиф Талыбов|Stuthedian" \
  --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias dco='dotfiles checkout'
alias dci='dotfiles commit -m'
alias dbr='dotfiles branch'
alias dad='dotfiles add'

bake()
{
  make "$@" 1>build.log
  local result=$?
  notify-send "done"
  return $result
}
