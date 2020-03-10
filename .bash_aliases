alias g='gedit'
alias mtargz='tar -xzf'
alias mtarbz='tar -xjf'
alias tips='(g ~/Docs/tips ~/Docs/key_combinations) &'
alias :q='exit'

#Git
alias gst='git status'
alias gstt='git status --untracked-files=no'
alias gdf='git diff'
alias gh='git hist'
alias gco='git checkout'
alias gci='git commit -m'
alias gbr='git branch'
alias gad='git add'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME \
        -c user.name=Stuthedian -c user.email=talybov.asif@yandex.ru'
