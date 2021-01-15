vicd()
{

    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

stand()
{
    tmux rename-window "stand"
    ~/stand.exp
}

Dshell()
{
  ~/Docs/builder-2.4.0/builder.sh shell
}

show_branches()
{
    synchronize_repo git rev-parse --abbrev-ref HEAD
}

synchronize_repo()
{
  for dir in *
  do
    if ! [ -d $dir ]; then
      continue
    fi
    cd "$dir"
    echo -e "\e[43m\e[30m$dir\e[0m"
    "$@"
    cd ..
  done
}

statall()
{
    for dir in ~/Docs/me-group-2.4.0/*
    do
        if ! [ -d $dir ]; then
            continue
        fi
        cd "$dir"
        echo -e "\e[43m\e[30m$dir\e[0m"
        git status -sb | head -1
        cd ..
    done
}
