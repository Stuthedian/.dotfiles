# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias g='gedit'
alias mtargz='tar -xzf'
alias mtarbz='tar -xjf'
alias tips='(g ~/Docs/tips ~/Docs/key_combinations) &'
stty -ixon
export PS1='\[\e[33;1m\]\w\n\[\e[36;1m\]\$\[\e[0m\] '
cd ~/Docs
export LONG_RUNNING_COMMAND_TIMEOUT=10
export IGNORE_WINDOW_CHECK=1
export EDITOR=vim
source /etc/profile.d/undistract-me.sh
CSCOPE_DB=/home/default/Docs/eltex-netconf/cscope.out; export CSCOPE_DB   
set -o vi

function stand()
{
	case $1 in 
	1) ssh 192.168.192.201 -l user;;
	2) ssh 192.168.192.211 -l user;;
	3) ssh 192.168.192.221 -l user;;
	*) echo "Expected apropriate stand number";;
	esac
}

function make_me5000()
{
	return
	if [ -z $1 ]; then
		echo "No target name"
		return
	fi
	if [ -z $2 ]; then
		echo "No target for make"
		return
	fi
	current_dir=$(pwd)
	firmware_path=~/Docs/eltex-netconf/base/me5000/out/fmc16
	firmware=firmware_2.3.0.$1.fmc16
	cd ~/Docs/eltex-netconf/base/me5000/fmc16
	~/Docs/builder/builder.sh make $2 || return
	cd ..
	~/Docs/builder/builder.sh make fs dist || return
	mv $firmware_path/firmware_2.3.0.DEVEL-BUILD.fmc16 $firmware_path/$firmware 
	cp $firmware_path/$firmware /srv/tftp
	echo "Firmware uploaded to tftp. Enter 'copy tftp://192.168.192.13/$firmware fs://firmware vrf mgmt-intf' on device"
	echo "copy tftp://192.168.192.13/$firmware fs://firmware vrf mgmt-intf" | xclip -i
	cd $current_dir 
}

function make_me5100()
{
	foo me5100 $1 $2
}

function make_me5200()
{
	foo me5200 $1 $2
}

function foo()
{
	current_dir=$(pwd)
	flash_leds="xdotool key --repeat 30 --repeat-delay 250 Num_Lock"

	if [ -z $2 ]; then
		echo "No target name"
		return
	fi
	if [ -z $3 ]; then
		echo "Warning: no target for make - building all"
	fi
	cd ~/Docs/eltex-netconf/base/$1
	~/Docs/builder/builder.sh make $3
	if [[ $? -ne 0 ]]; then
		cd $current_dir
		$flash_leds
		return
	fi
	~/Docs/builder/builder.sh make fs dist
	if [[ $? -ne 0 ]]; then
		cd $current_dir
		$flash_leds
		return
	fi
	mv ~/Docs/eltex-netconf/base/$1/out/$1/firmware_2.3.0.DEVEL-BUILD.$1 ~/Docs/eltex-netconf/base/$1/out/$1/firmware_2.3.0.$2.$1
	cp ~/Docs/eltex-netconf/base/$1/out/$1/firmware_2.3.0.$2.$1 /srv/tftp
	echo "Firmware uploaded to tftp. Enter 'copy tftp://192.168.192.13/firmware_2.3.0.$2.$1 fs://firmware vrf mgmt-intf' on device"
	echo "copy tftp://192.168.192.13/firmware_2.3.0.$2.$1 fs://firmware vrf mgmt-intf" | xclip -i
	$flash_leds
	cd $current_dir 
}

function synchronize_repo()
{
	for dir in * 
	do
		if ! [ -d $dir ]; then
			continue
		fi
		cd "$dir"
		"$@"
		cd ..
	done
}
