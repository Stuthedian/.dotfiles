alias g='gedit'
alias mtargz='tar -xzf'
alias mtarbz='tar -xjf'
alias tips='(gvim ~/Docs/tips ~/Docs/key_combinations) &'
alias :q='exit'

#Git
alias gst='git status'
alias gstt='git status --untracked-files=no'
alias gdf='git diff'
alias gh='git log --perl-regexp --author="Асиф Талыбов|Stuthedian"\
  --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias gco='git checkout'
alias gci='git commit -m'
alias gbr='git branch'
alias gad='git add'

#Git dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias dst='dotfiles status'
alias ddf='dotfiles diff'
alias dh='dotfiles log --perl-regexp --author="Асиф Талыбов|Stuthedian" \
  --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias dco='dotfiles checkout'
alias dci='dotfiles commit -m'
alias dbr='dotfiles branch'
alias dad='dotfiles add'
